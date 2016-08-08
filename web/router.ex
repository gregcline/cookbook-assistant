defmodule Cookbook.Router do
  use Cookbook.Web, :router

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

  scope "/", Cookbook do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", only: [:new, :create, :delete]
    resources "/users", only: [:new, :create]
    resources "/recipes", only: [:new, :create, :index, :show]
    resources "/shopping", only: [:index, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cookbook do
  #   pipe_through :api
  # end
end
