defmodule Cookbook.RecipeBook do
  use Cookbook.Web, :model
  import Ecto.Query, only: [from: 2]
  alias Cookbook.RecipeBook
  
  schema "recipe_books" do
    belongs_to :user, Cookbook.User
    belongs_to :recipe, Cookbook.Recipe

    timestamps
  end

  def changeset(model, params) do
    model
    |> cast(params, ~w(user_id recipe_id)a)
    |> validate_required(~w(user_id recipe_id)a)
    |> unique_constraint(:recipe_id_user_id, message: "This recipe is already in your book")
  end

  def filter_by_user(user_id) do
    from u in RecipeBook,
      where: u.user_id == ^user_id,
      preload: [:recipe]
  end

  def delete_where(params) do
    from r in RecipeBook,
      where: ^params
  end
end