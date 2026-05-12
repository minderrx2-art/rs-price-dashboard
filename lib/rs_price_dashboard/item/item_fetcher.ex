defmodule RsPriceDashboard.ItemFetcher do
  @mappings_url "https://prices.runescape.wiki/api/v1/osrs/mapping"
  @headers [{"User-Agent", "minderrx2@gmail.com Elixir price project"}]

  # Populate the items table with the data from the mappings API
  # mix run -e "RsPriceDashboard.ItemFetcher.fetch_items()"
  def fetch_items() do
    case Req.get(@mappings_url, headers: @headers) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        body
        |> Enum.map(fn item ->
          %RsPriceDashboard.ItemStruct{
            item_id: item["id"],
            name: item["name"],
            icon: item["icon"],
            members: item["members"],
            low_alch: item["lowalch"],
            high_alch: item["highalch"],
            limit: item["limit"],
            examine: item["examine"]
          }
        end)
        |> RsPriceDashboard.ItemStore.Items.upsert_items()
    end
  end
end
