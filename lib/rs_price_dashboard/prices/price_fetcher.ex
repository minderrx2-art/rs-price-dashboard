defmodule RsPriceDashboard.PriceFetcher do
  @url "https://prices.runescape.wiki/api/v1/osrs/latest"
  @headers [{"User-Agent", "minderrx2@gmail.com Elixir price project"}]
  @fetch_interval :timer.minutes(5)

  use GenServer
  require Logger
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def fetch_prices() do
    GenServer.call(__MODULE__, :fetch_prices)
  end

  @impl true
  def init(args) do
    send(self(), :fetch)
    {:ok, args}
  end

  @impl true
  def handle_info(:fetch, state) do
    do_fetch()
    schedule_fetch()
    {:noreply, state}
  end

  @impl true
  def handle_call(:fetch_prices, _from, state) do
    {:reply, do_fetch(), state}
  end

  defp do_fetch() do
    case Req.get(@url, headers: @headers) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        body
        |> Map.get("data")
        |> parse_prices()
        |> store_prices()

      {:error, error} ->
        {:error, error}
    end
  end

  defp store_prices(prices) do
    changed_prices = RsPriceDashboard.PriceEts.get_stored_item_prices() |> RsPriceDashboard.PriceAnalyzer.get_changed(prices)
    with {:ok, :saved} <- RsPriceDashboard.PriceEts.save_item_prices(changed_prices),
         {:ok, _} <- RsPriceDashboard.Prices.upsert_prices(changed_prices) do
      :ok
    else
      {:error, reason} -> Logger.error("DB upsert failed: #{inspect(reason)}")
    end
  end

  defp schedule_fetch(), do: Process.send_after(self(), :fetch, @fetch_interval)

  defp parse_prices(data) do
    Enum.map(data, fn {item_id, item} ->
      %RsPriceDashboard.PriceStruct{
        item_id:   String.to_integer(item_id),
        high:      item["high"],
        low:       item["low"],
        high_time: item["highTime"],
        low_time:  item["lowTime"]
      }
    end)
  end
end
