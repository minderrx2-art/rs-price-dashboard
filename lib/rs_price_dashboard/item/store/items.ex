defmodule RsPriceDashboard.ItemStore.Items do
  alias RsPriceDashboard.Repo
  alias RsPriceDashboard.ItemStore.Item

  def upsert_items(items) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    records = Enum.map(items, fn i ->
      %{item_id: i.item_id, name: i.name, icon: i.icon, members: i.members, low_alch: i.low_alch, high_alch: i.high_alch, limit: i.limit, examine: i.examine, inserted_at: now, updated_at: now}
    end)
    case Repo.insert_all(
      Item,
      records,
      on_conflict: {:replace, [:name, :icon, :members, :low_alch, :high_alch, :limit, :examine, :updated_at]},
      conflict_target: :item_id
    ) do
      {count, _} -> {:ok, count}
    end
  end

  def get_all_items() do
    Repo.all(Item)
  end
end
