defmodule Excelmerger.ProductOrderTest do
  use Excelmerger.ModelCase

  alias Excelmerger.ProductOrder

  @valid_attrs %{qty: 42, sku: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductOrder.changeset(%ProductOrder{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductOrder.changeset(%ProductOrder{}, @invalid_attrs)
    refute changeset.valid?
  end
end
