defmodule RsPriceDashboard.PriceStore.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_prices" do
    field :item_id,   :integer
    field :high,      :integer
    field :low,       :integer
    field :high_time, :integer
    field :low_time,  :integer
    timestamps()
  end

  def changeset(price, attrs) do
    price
    |> cast(attrs, [:item_id, :high, :low, :high_time, :low_time])
    |> validate_required([:item_id])
    |> unique_constraint(:item_id)
  end
end
