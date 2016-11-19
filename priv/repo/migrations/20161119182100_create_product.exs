defmodule Excelmerger.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :sku, :string
      add :title, :string
      add :inventory_id, :integer

      timestamps()
    end
    create index(:products, [:sku], unique: true)

  end
end
