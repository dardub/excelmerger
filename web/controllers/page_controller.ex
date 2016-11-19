defmodule Excelmerger.PageController do
  use Excelmerger.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
