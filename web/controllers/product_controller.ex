defmodule Excelmerger.ProductController do
  use Excelmerger.Web, :controller

  alias Excelmerger.Product
  alias Excelmerger.Spreadsheets
  # alias Excelmerger.ExcelFile

  def index(conn, _params) do
    products = Repo.all(Product)
    product_count = Repo.aggregate(Product, :count, :id)
    changeset = Product.changeset(%Product{})
    # render(conn, "index.html", products: products, changeset: changeset)
    render(conn, "index.html", product_count: product_count, changeset: changeset)
  end

  def update_products(conn, %{"product" => %{"file" => file}}) do

    # Clear all and start fresh
    Repo.delete_all(Product)

    scope = %{ id: :master_product_list }

    file_url = "/Users/darren/Desktop/elixirmerge/excel_import.xlsx"
    File.cp(file.path, file_url)

    # Below for using arc
    # {:ok, filename } = ExcelFile.store({file, scope})
    # file_url = ExcelFile.url({filename, scope}, :original, signed: true)


    params_list =
      case Xlsxir.extract(file_url, 0, true) do
        {:ok, _time} ->
          Xlsxir.get_list
          |> Spreadsheets.transform_header([:inventory_id, :title, :qty, :sku])
          |> Spreadsheets.to_map
          |> Enum.filter(fn(x) -> Map.has_key?(x, :sku) end)
          |> Spreadsheets.filter_data([:inventory_id, :title, :sku])
          |> Spreadsheets.add_timestamps
          |> Enum.sort(&(&1.sku > &2.sku)) # Sort by sku for dedup function
          |> Enum.dedup_by(fn (x) -> x.sku end)

        {:error, message} ->
          IO.puts 'Error: #{message}'
          []
      end
    Xlsxir.close

    Enum.chunk(params_list, 500, 500, [])
    |> Enum.map(fn(batch_list) ->
      Repo.insert_all(Product, batch_list)
    end)

    IO.puts "*****************************"
    IO.puts Enum.count(params_list)
    IO.puts "*****************************"

    conn
      |> put_flash(:info, "Product created successfully.")
      |> redirect(to: product_path(conn, :index))
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: product_path(conn, :show, product))
      {:error, changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: product_path(conn, :index))
  end
end
