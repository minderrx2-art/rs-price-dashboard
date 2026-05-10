defmodule RsPriceDashboard.PriceAnalyzer do
  def get_changed(previous, current) do
    Enum.filter(current, fn current_price ->
      case Map.get(previous, current_price.item_id) do
        nil -> true
        previous_price -> current_price != previous_price
      end
    end)
  end

  def filter(prices, criteria) do
    Enum.filter(prices, fn price ->
      criteria.(price)
    end)
  end
end
