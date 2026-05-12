defmodule RsPriceDashboard.Prices do
  alias RsPriceDashboard.Repo
  alias RsPriceDashboard.PriceStore.Price

  def upsert_prices(prices) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    records = Enum.map(prices, fn p ->
      %{item_id: p.item_id, high: p.high,
        low: p.low, high_time: p.high_time, low_time: p.low_time,
        inserted_at: now, updated_at: now}
    end)
    case Repo.insert_all(
      Price,
      records,
      on_conflict: {:replace, [:high, :low, :high_time, :low_time, :updated_at]},
      conflict_target: :item_id
    ) do
      {count, _} -> {:ok, count}
    end
  end
end
