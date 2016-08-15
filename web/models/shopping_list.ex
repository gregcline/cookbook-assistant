defmodule Cookbook.ShoppingList do
  use Cookbook.Web, :model

  schema "shopping_lists" do
    belongs_to :user, Cookbook.User
    belongs_to :recipe, Cookbook.Recipe

    timestamps
  end
end