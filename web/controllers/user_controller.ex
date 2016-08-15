defmodule Cookbook.UserController do
  @moduledoc """
  Handles creating new users
  """
  use Cookbook.Web, :controller
  alias Cookbook.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Cookbook.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: recipe_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end