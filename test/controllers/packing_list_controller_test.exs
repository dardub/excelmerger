defmodule Excelmerger.PackingListControllerTest do
  use Excelmerger.ConnCase

  alias Excelmerger.PackingList
  @valid_attrs %{merged: 42, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, packing_list_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing packing lists"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, packing_list_path(conn, :new)
    assert html_response(conn, 200) =~ "New packing list"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, packing_list_path(conn, :create), packing_list: @valid_attrs
    assert redirected_to(conn) == packing_list_path(conn, :index)
    assert Repo.get_by(PackingList, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, packing_list_path(conn, :create), packing_list: @invalid_attrs
    assert html_response(conn, 200) =~ "New packing list"
  end

  test "shows chosen resource", %{conn: conn} do
    packing_list = Repo.insert! %PackingList{}
    conn = get conn, packing_list_path(conn, :show, packing_list)
    assert html_response(conn, 200) =~ "Show packing list"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, packing_list_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    packing_list = Repo.insert! %PackingList{}
    conn = get conn, packing_list_path(conn, :edit, packing_list)
    assert html_response(conn, 200) =~ "Edit packing list"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    packing_list = Repo.insert! %PackingList{}
    conn = put conn, packing_list_path(conn, :update, packing_list), packing_list: @valid_attrs
    assert redirected_to(conn) == packing_list_path(conn, :show, packing_list)
    assert Repo.get_by(PackingList, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    packing_list = Repo.insert! %PackingList{}
    conn = put conn, packing_list_path(conn, :update, packing_list), packing_list: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit packing list"
  end

  test "deletes chosen resource", %{conn: conn} do
    packing_list = Repo.insert! %PackingList{}
    conn = delete conn, packing_list_path(conn, :delete, packing_list)
    assert redirected_to(conn) == packing_list_path(conn, :index)
    refute Repo.get(PackingList, packing_list.id)
  end
end
