defmodule Cookbook.RecipeBookController do
  @moduledoc """
  Handles the user's recipe book.
  """
  use Cookbook.Web, :controller
  alias Cookbook.RecipeBook
  alias Cookbook.Repo

  plug :authenticate_user when action in [:edit]
  
  def edit(conn, %{"id" => user_id}) do
    query = RecipeBook.filter_by_user(String.to_integer(user_id))
    recipe_book_entries = Repo.all(query)
    recipes = recipe_book_entries
    |> Enum.map(fn %RecipeBook{recipe: recipe} ->
      recipe
    end)
    render conn, "edit.html", recipes: recipes
  end

@doc """
This clause matches when we receive an "add" request.
This is probably a bad way to do it.
"""
  def update(conn, %{"id" => user_id, "update" => %{"action" => "add", "recipe_id" => recipe_id, "req_path" => req_path}}) do
    changeset = RecipeBook.changeset(%RecipeBook{}, %{"user_id" => user_id, "recipe_id" => recipe_id})
    case Repo.insert(changeset) do
      {:ok, book_entry} ->
        book_entry = Repo.preload(book_entry, :recipe)
        conn
        |> put_flash(:info, "#{book_entry.recipe.name}, added to your recipe book")
        |> redirect(to: req_path)
      {:error, %Ecto.Changeset{errors: [recipe_id_user_id: {message, []}]}} ->
        conn
        |> put_flash(:error, "#{message}")
        |> redirect(to: req_path)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Sorry, something went wrong and we couldn't add that to your recipe book.\n Please try again later.")
        |> redirect(to: req_path)
    end
  end

@doc """
This clause matches when we receive a "delete" request.
This is probably a bad way to do it.
"""
  def update(conn, %{"id" => user_id, "update" => %{"action" => "del", "recipe_id" => recipe_id, "req_path" => req_path}}) do
    delete_query = RecipeBook.delete_where([recipe_id: recipe_id, user_id: user_id])
    case Repo.delete_all(delete_query) do
      {0, _} ->
        conn
        |> put_flash(:error, "Unable to delete the recipe from your book, it seems it wasn't there to begin with.")
        |> redirect(to: req_path)
      {1, _} ->
        conn
        |> put_flash(:info, "The recipe has been removed.")
        |> redirect(to: req_path)
      {_, _} ->
        conn
        |> put_flash(:error, "Unable to delete the recipe from your book.")
        |> redirect(to: req_path)
    end
  end
end