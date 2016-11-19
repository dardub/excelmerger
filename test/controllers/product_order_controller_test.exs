defmodule Excelmerger.ProductOrderControllerTest do
  use Excelmerger.ConnCase

  alias Excelmerger.ProductOrder
  @valid_attrs %{qty: 42, sku: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_order_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing product orders"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, product_order_path(conn, :new)
    assert html_response(conn, 200) =~ "New product order"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, product_order_path(conn, :create), product_order: @valid_attrs
    assert redirected_to(conn) == product_order_path(conn, :index)
    assert Repo.get_by(ProductOrder, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, product_order_path(conn, :create), product_order: @invalid_attrs
    assert html_response(conn, 200) =~ "New product order"
  end

  test "shows chosen resource", %{conn: conn} do
    product_order = Repo.insert! %ProductOrder{}
    conn = get conn, product_order_path(conn, :show, product_order)
    assert html_response(conn, 200) =~ "Show product order"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_order_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    product_order = Repo.insert! %ProductOrder{}
    conn = get conn, product_order_path(conn, :edit, product_order)
    assert html_response(conn, 200) =~ "Edit product order"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    product_order = Repo.insert! %ProductOrder{}
    conn = put conn, product_order_path(conn, :update, product_order), product_order: @valid_attrs
    assert redirected_to(conn) == product_order_path(conn, :show, product_order)
    assert Repo.get_by(ProductOrder, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    product_order = Repo.insert! %ProductOrder{}
    conn = put conn, product_order_path(conn, :update, product_order), product_order: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit product order"
  end

  test "deletes chosen resource", %{conn: conn} do
    product_order = Repo.insert! %ProductOrder{}
    conn = delete conn, product_order_path(conn, :delete, product_order)
    assert redirected_to(conn) == product_order_path(conn, :index)
    refute Repo.get(ProductOrder, product_order.id)
  end
end
