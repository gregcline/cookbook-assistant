defmodule Cookbook.Router do
  use Cookbook.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Cookbook.Auth, repo: Cookbook.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cookbook do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:new, :create]
    resources "/recipes", RecipeController, only: [:new, :create, :index, :show]
    resources "/shopping", ShoppingController, only: [:index, :edit, :update]
    resources "/book", RecipeBookController, only: [:edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cookbook do
  #   pipe_through :api
  # end
end
