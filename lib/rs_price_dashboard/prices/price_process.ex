defmodule RsPriceDashboard.PriceProcess do
  use GenServer

  alias RsPriceDashboard.PriceStruct

  def start_link(%PriceStruct{item_id: item_id} = price) do
    GenServer.start_link(__MODULE__, price, name: via(item_id))
  end

  def update_or_start(%PriceStruct{item_id: item_id} = price) do
    case Registry.lookup(RsPriceDashboard.PriceRegistry, item_id) do
      [{pid, _}] ->
        GenServer.cast(pid, {:update, price})

      [] ->
        DynamicSupervisor.start_child(RsPriceDashboard.PriceSupervisor, {__MODULE__, price})
    end
  end

  @impl true
  def init(price) do
    {:ok, price}
  end

  @impl true
  def handle_cast({:update, price}, _state) do
    Phoenix.PubSub.broadcast(RsPriceDashboard.PubSub, "prices", {:price_updated, price})
    {:noreply, price}
  end

  defp via(item_id), do: {:via, Registry, {RsPriceDashboard.PriceRegistry, item_id}}
end
