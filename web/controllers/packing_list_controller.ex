defmodule Excelmerger.PackingListController do
  use Excelmerger.Web, :controller

  alias Excelmerger.PackingList

  def index(conn, _params) do
    packing_lists = Repo.all(PackingList)
    render(conn, "index.html", packing_lists: packing_lists)
  end

  def new(conn, _params) do
    changeset = PackingList.changeset(%PackingList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"packing_list" => packing_list_params}) do
    changeset = PackingList.changeset(%PackingList{}, packing_list_params)

    case Repo.insert(changeset) do
      {:ok, _packing_list} ->
        conn
        |> put_flash(:info, "Packing list created successfully.")
        |> redirect(to: packing_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
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
