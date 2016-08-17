defmodule Cookbook.RecipeController do
  @moduledoc """
  Handles adding, viewing and editing recipes.
  """
  use Cookbook.Web, :controller
  alias Cookbook.Recipe
  alias Cookbook.Repo

  def recipes do
    [%{id: 1,
      name: "Recipe 1",
      ingredients: [%{name: "broccoli", amount: "1 head"},
                    %{name: "salt", amount: "a pinch"}],
      instructions: "First steam the broccoli.
      Then salt to taste.",
      tags: ["vegetable", "easy"],
      ratings: [5, 4, 3, 5]},
    %{id: 2,
      name: "Recipe 2",
      ingredients: [%{name: "salmon", amount: "1 filet"},
                    %{name: "salt", amount: "a pinch"},
                    %{name: "lemon juice", amount: "a splash"}],
      instructions: "Broil the salmon on one side for 6 minutes.
      Turn filet over, splash the lemon juice on and sprinkle with salt.
      Broil for 6 more minutes",
      tags: ["fish", "easy"],
      ratings: [5, 4, 3, 5]}]
  end

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
    render conn, "index.html", recipes: recipes
  end

  def show(conn, %{"id" => id}) do
    recipe = Repo.get(Recipe, id)
    |> Repo.preload(:ingredients)
    render conn, "show.html", recipe: recipe
  end
end
