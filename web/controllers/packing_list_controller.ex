defmodule Excelmerger.PackingListController do
  use Excelmerger.Web, :controller

  alias Excelmerger.PackingList
  alias Excelmerger.Spreadsheets
  alias Excelmerger.Utilities
  alias Excelmerger.ProductOrder
  alias Excelmerger.Product

  def index(conn, _params) do
    packing_lists = Repo.all(PackingList)
    render(conn, "index.html", packing_lists: packing_lists)
  end

  def new(conn, _params) do
    changeset = PackingList.changeset(%PackingList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"packing_list" => packing_list_params}) do
    %{"file" => file, "name" => name, "merged" => merged } = packing_list_params

    changeset = PackingList.changeset(%PackingList{}, %{name: name, merged: Utilities.string_bool_to_int(merged)})

    temp_file =
      DateTime.utc_now
      |> DateTime.to_string
      |> :erlang.md5
      |> Base.encode16(case: :lower)
      |> (&("/tmp/sublist_import_#{&1}.xlsx")).()



    File.cp(file.path, temp_file)

    new_packing_list = case Repo.insert(changeset) do

      {:ok, _packing_list} ->
        _packing_list.id
      #   conn
      #   |> put_flash(:info, "Packing list created successfully.")
      #   |> redirect(to: packing_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end



    # Insert Related records
    params_list =
      case Xlsxir.extract(temp_file, 0, true) do
        {:ok, _time} ->
          Xlsxir.get_list
          |> Spreadsheets.transform_header([:sku, :qty])
          |> Spreadsheets.to_map
          |> Enum.filter(fn(x) -> Map.has_key?(x, :sku) end)
          |> Spreadsheets.filter_data([:sku, :qty])
          |> Spreadsheets.add_timestamps
          |> Enum.map(fn(row) ->
              Map.merge(row, %{
                packing_list_id: new_packing_list,
                sku: Utilities.cast_string(row.sku),
                qty: Utilities.cast_int(row.qty),
              })
            end)
          # |> Enum.dedup_by(fn (x) -> x.sku end)
          # |> Enum.sort(&(&1.sku > &2.sku)) # Sort by sku for dedup function

        {:error, message} ->
          IO.puts 'Error: #{message}'
          []
      end
    Xlsxir.close

    case Repo.insert_all(ProductOrder, params_list) do
      {:error, message} ->
        render(conn, "new.html", changeset: changeset)

      {insert_count, _} ->
        conn
        |> put_flash(:info, "Packing list created successfully.")
        |> redirect(to: packing_list_path(conn, :index))
    end

  end

  def show(conn, %{"id" => id}) do
    packing_list = Repo.get!(PackingList, id)
    render(conn, "show.html", packing_list: packing_list)
  end

  def edit(conn, %{"id" => id}) do
    packing_list = Repo.get!(PackingList, id)
    changeset = PackingList.changeset(packing_list)
    render(conn, "edit.html", packing_list: packing_list, changeset: changeset)
  end

  def download_csv(conn, %{"id" => id}) do
    PackingList
    |> where(master_object_class: "Shop_Product")
    |> join(:inner, [f], p in ShopProduct, f.master_object_id == p.id)

    query = from po in ProductOrder,
              left_join: p in Product, where: p.sku == po.sku,
              select: {  p.inventory_id,  p.title, po.qty, po.sku }

    packing_list = Repo.get!(PackingList, id) |> Repo.preload(product_orders: query)

    filename   = build_csv(["InventoryId\tTitle\tQuantity\tBarCode"], packing_list.product_orders)

    conn
    |> put_resp_header("content-disposition", ~s(attachment; filename="export-#{packing_list.name}-#{DateTime.to_unix(DateTime.utc_now)}.txt"))
    |> send_file(200, filename)
  end

  def build_csv(header, rows) do
    exports_file = "/tmp/export-#{DateTime.to_unix(DateTime.utc_now)}.csv"
    {:ok, file} = File.open exports_file, [:write]

    data = rows
      |> Enum.map(fn(row) ->
        Tuple.to_list(row) |> Enum.join("\t")
      end)

    IO.inspect [header] ++ data

    file
      |> IO.binwrite(header ++ data |> Enum.join("\n"))
      |> File.close

    exports_file
  end

  def update(conn, %{"id" => id, "packing_list" => packing_list_params}) do
    packing_list = Repo.get!(PackingList, id)
    changeset = PackingList.changeset(packing_list, packing_list_params)

    case Repo.update(changeset) do
      {:ok, packing_list} ->
        conn
        |> put_flash(:info, "Packing list updated successfully.")
        |> redirect(to: packing_list_path(conn, :show, packing_list))
      {:error, changeset} ->
        render(conn, "edit.html", packing_list: packing_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    packing_list = Repo.get!(PackingList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(packing_list)

    conn
    |> put_flash(:info, "Packing list deleted successfully.")
    |> redirect(to: packing_list_path(conn, :index))
  end
end
