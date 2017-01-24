defmodule Excelmerger.Router do
  use Excelmerger.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Excelmerger do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/product_orders", ProductOrderController

    get "/packing_lists/:id/download_csv", PackingListController, :download_csv
    resources "/packing_lists", PackingListController

    post "/products/update_products", ProductController, :update_products
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Excelmerger do
  #   pipe_through :api
  # end
end
