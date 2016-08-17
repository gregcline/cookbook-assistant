defmodule Cookbook.SessionController do
  @moduledoc """
  Handles creating new sessions and dropping sessions.
  """
  use Cookbook.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
  
  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Cookbook.Auth.login_by_username_and_pass(conn, user, pass, repo: Cookbook.Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back.")
        |> redirect(to: recipe_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Cookbook.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end