defmodule RsPriceDashboard.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :item_id,   :integer, null: false
      add :name,      :string, null: false
      add :icon,      :string, null: false
      add :members,   :boolean, null: false
      add :low_alch,  :integer
      add :high_alch, :integer
      add :limit,     :integer
      add :examine,   :string
      timestamps()
    end
    create unique_index(:items, [:item_id])
  end
end
