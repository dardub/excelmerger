defmodule Excelmerger.ProductOrderController do
  use Excelmerger.Web, :controller

  alias Excelmerger.ProductOrder

  def index(conn, _params) do
    product_orders = Repo.all(ProductOrder)
    render(conn, "index.html", product_orders: product_orders)
  end

  def new(conn, _params) do
    changeset = ProductOrder.changeset(%ProductOrder{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product_order" => product_order_params}) do
    changeset = ProductOrder.changeset(%ProductOrder{}, product_order_params)

    case Repo.insert(changeset) do
      {:ok, _product_order} ->
        conn
        |> put_flash(:info, "Product order created successfully.")
        |> redirect(to: product_order_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_order = Repo.get!(ProductOrder, id)
    render(conn, "show.html", product_order: product_order)
  end

  def edit(conn, %{"id" => id}) do
    product_order = Repo.get!(ProductOrder, id)
    changeset = ProductOrder.changeset(product_order)
    render(conn, "edit.html", product_order: product_order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product_order" => product_order_params}) do
    product_order = Repo.get!(ProductOrder, id)
    changeset = ProductOrder.changeset(product_order, product_order_params)

    case Repo.update(changeset) do
      {:ok, product_order} ->
        conn
        |> put_flash(:info, "Product order updated successfully.")
        |> redirect(to: product_order_path(conn, :show, product_order))
      {:error, changeset} ->
        render(conn, "edit.html", product_order: product_order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_order = Repo.get!(ProductOrder, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product_order)

    conn
    |> put_flash(:info, "Product order deleted successfully.")
    |> redirect(to: product_order_path(conn, :index))
  end
end
