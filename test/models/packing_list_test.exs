defmodule Excelmerger.PackingListTest do
  use Excelmerger.ModelCase

  alias Excelmerger.PackingList

  @valid_attrs %{merged: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PackingList.changeset(%PackingList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PackingList.changeset(%PackingList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
