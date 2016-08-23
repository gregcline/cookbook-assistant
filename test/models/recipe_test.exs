defmodule Cookbook.RecipeTest do
  use Cookbook.ConnCase
  alias Cookbook.Recipe

  test "new recipe changeset" do
    recipe_params = %{"name" => "test",
                      "ingredients_string" =>
                        "ingredient1, amount; ingredient2, amount",
                      "tags_string" => "tag1, tag2",
                      "instructions" => "these are instructions",
                      "ratings" => "5"}
    changeset = Recipe.new_recipe_changeset(%Recipe{}, recipe_params)
    assert changeset.valid?

    bad_recipe_params = %{"name" => "test",
                      "ingredients_string" =>
                        "ingredient1, amount; ingredient2",
                      "tags_string" => "tag1, tag2",
                      "instructions" => "these are instructions",
                      "ratings" => "5"}
    bad_changeset = Recipe.new_recipe_changeset(%Recipe{}, bad_recipe_params)
    refute bad_changeset.valid?
  end
end