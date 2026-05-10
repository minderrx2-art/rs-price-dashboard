defmodule RsPriceDashboard.PriceEts do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def save_item_prices(item_prices) do
    records = Enum.map(item_prices, fn p -> {p.item_id, p} end)
    :ets.insert(:item_prices, records)
    {:ok, :saved}
  end

  def get_stored_item_prices do
    :ets.tab2list(:item_prices)
    |> Map.new(fn {item_id, price} -> {item_id, price} end)
  end

  def get_item_price(item_id) do
    case :ets.lookup(:item_prices, item_id) do
      [{_id, price}] -> {:ok, price}
      [] -> {:error, :not_found}
    end
  end

  @impl true
  def init(args) do
    :ets.new(:item_prices, [:set, :public, :named_table])
    {:ok, args}
  end
end
