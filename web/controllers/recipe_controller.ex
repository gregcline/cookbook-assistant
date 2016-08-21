defmodule Cookbook.RecipeController do
  @moduledoc """
  Handles adding, viewing and editing recipes.
  """
  use Cookbook.Web, :controller
  alias Cookbook.Recipe
  alias Cookbook.Repo

  plug :authenticate_user when action in [:new]

  def new(conn, _params) do
    changeset = Recipe.changeset(%Recipe{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"recipe" => recipe_params}) do
    changeset = Recipe.new_recipe_changeset(%Recipe{}, recipe_params)
    case Repo.insert(changeset) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "#{recipe.name} created!")
        |> redirect(to: recipe_path(conn, :show, recipe.id))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    recipes = Repo.all(Recipe)
    render conn, "index.html", recipes: recipes
  end

  def show(conn, %{"id" => id}) do
    recipe = Repo.get(Recipe, id)
    |> Repo.preload(:ingredients)
    render conn, "show.html", recipe: recipe
  end
end
