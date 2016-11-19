defmodule Excelmerger.ProductTest do
  use Excelmerger.ModelCase

  alias Excelmerger.Product

  @valid_attrs %{inventory_id: 42, sku: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
