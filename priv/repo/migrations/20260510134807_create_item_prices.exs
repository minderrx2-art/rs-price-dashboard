defmodule RsPriceDashboard.Repo.Migrations.CreateItemPrices do
  use Ecto.Migration

  def change do
    create table(:item_prices) do
      add :item_id,   :integer, null: false
      add :high,      :integer
      add :low,       :integer
      add :high_time, :integer
      add :low_time,  :integer
      timestamps()
    end
    create unique_index(:item_prices, [:item_id])
  end
end
