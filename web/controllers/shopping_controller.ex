defmodule Cookbook.ShoppingController do
  @moduledoc """
  Handles the shopping list.
  """
  use Cookbook.Web, :controller
  alias Cookbook.ShoppingList
  alias Cookbook.Repo

  plug :authenticate_user when action in [:index, :edit, :update]

  def index(conn, _params) do
    query = ShoppingList.filter_by_user(conn.assigns.current_user.id)
    shopping_list_entries = Repo.all(query)
    ingredients = shopping_list_entries
    |> Enum.flat_map(fn %ShoppingList{recipe: recipe} ->
      recipe = Repo.preload(recipe, :ingredients)
      recipe.ingredients
    end)
    render conn, "index.html", ingredients: ingredients
  end

  def edit(conn, %{"id" => user_id}) do
    query = ShoppingList.filter_by_user(String.to_integer(user_id))
    shopping_list_entries = Repo.all(query)
    recipes = shopping_list_entries
    |> Enum.map(fn %ShoppingList{recipe: recipe} ->
      recipe
    end)
    render conn, "edit.html", recipes: recipes
  end

@doc """
This clause matches when we receive an "add" request.
This is probably a bad way to do it.
"""
  def update(conn, %{"id" => user_id, "update" => %{"action" => "add", "recipe_id" => recipe_id, "req_path" => req_path}}) do
    changeset = ShoppingList.changeset(%ShoppingList{}, %{"user_id" => user_id, "recipe_id" => recipe_id})
    case Repo.insert(changeset) do
      {:ok, shopping_entry} ->
        shopping_entry = Repo.preload(shopping_entry, :recipe)
        conn
        |> put_flash(:info, "#{shopping_entry.recipe.name}, added to your shopping list.")
        |> redirect(to: req_path)
      {:error, %Ecto.Changeset{errors: [recipe_id_user_id: {message, []}]}} ->
        conn
        |> put_flash(:error, "#{message}")
        |> redirect(to: req_path)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Sorry, something went wrong and we couldn't add that to your shopping list.")
        |> redirect(to: req_path)
    end
  end

  @doc """
  This clause matches when we receive a "delete" request.
  This is probably a bad way to do it.
  """
  def update(conn, %{"id" => user_id, "update" => %{"action" => "del", "recipe_id" => recipe_id, "req_path" => req_path}}) do
    delete_query = ShoppingList.delete_where([recipe_id: recipe_id, user_id: user_id])
    case Repo.delete_all(delete_query) do
      {0, _} ->
        conn
        |> put_flash(:error, "Unable to delete the recipe from your list, it seems it wasn't there to begin with.")
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