defmodule Cookbook.ShoppingList do
  use Cookbook.Web, :model
  alias Cookbook.ShoppingList

  schema "shopping_lists" do
    belongs_to :user, Cookbook.User
    belongs_to :recipe, Cookbook.Recipe

    timestamps
  end

  def changeset(model, params) do
    model
    |> cast(params, ~w(user_id recipe_id)a)
    |> validate_required(~w(user_id recipe_id)a)
    |> unique_constraint(:recipe_id_user_id, message: "This recipe is already on your list.")
  end

  def filter_by_user(user_id) do
    from s in ShoppingList,
      where: s.user_id == ^user_id,
      preload: [:recipe]
  end

  def delete_where(params) do
    from s in ShoppingList,
      where: ^params
  end
end