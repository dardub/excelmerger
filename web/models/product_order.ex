defmodule Excelmerger.ProductOrder do
  use Excelmerger.Web, :model

  schema "product_orders" do
    field :qty, :integer
    field :sku, :string
    belongs_to :packing_list, Excelmerger.PackingList

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:qty, :sku])
    |> validate_required([:qty, :sku])
  end
end
