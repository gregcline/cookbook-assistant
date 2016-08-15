defmodule Cookbook.RecipeBook do
  use Cookbook.Web, :model
  
  schema "recipe_books" do
    belongs_to :user, Cookbook.User
    belongs_to :recipe, Cookbook.Recipe

    timestamps
  end
end