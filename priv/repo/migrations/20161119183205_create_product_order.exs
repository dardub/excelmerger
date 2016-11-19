defmodule Excelmerger.Repo.Migrations.CreateProductOrder do
  use Ecto.Migration

  def change do
    create table(:product_orders) do
      add :qty, :integer
      add :sku, :string
      add :packing_list_id, references(:packing_lists, on_delete: :nothing)

      timestamps()
    end
    create index(:product_orders, [:packing_list_id])

  end
end
