defmodule RsPriceDashboard.ItemStore.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :item_id,   :integer
    field :name,      :string
    field :icon,      :string
    field :members,   :boolean
    field :low_alch,  :integer
    field :high_alch, :integer
    field :limit,   :integer
    field :examine, :string
    timestamps()
  end


  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_id, :name, :icon, :members, :low_alch, :high_alch, :limit, :examine])
    |> validate_required([:item_id, :name, :icon, :members])
    |> unique_constraint(:item_id)
  end
end
