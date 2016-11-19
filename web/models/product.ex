defmodule Excelmerger.Product do
  use Excelmerger.Web, :model

  schema "products" do
    field :sku, :string
    field :title, :string
    field :inventory_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:sku, :title, :inventory_id])
    |> validate_required([:sku, :title, :inventory_id])
  end
end
