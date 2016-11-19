defmodule Excelmerger.Repo.Migrations.CreatePackingList do
  use Ecto.Migration

  def change do
    create table(:packing_lists) do
      add :name, :string
      add :merged, :integer

      timestamps()
    end

  end
end
