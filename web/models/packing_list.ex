defmodule Excelmerger.PackingList do
  use Excelmerger.Web, :model

  schema "packing_lists" do
    field :name, :string
    field :merged, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :merged])
    |> validate_required([:name, :merged])
  end
end
