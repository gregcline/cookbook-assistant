defmodule Cookbook.Repo.Migrations.AddRecipeIngredientsAncestorsTable do
  use Ecto.Migration

  def up do
    create table(:recipes) do
      add :name, :string
      add :instructions, :string
      add :tags, {:array, :string}, default: []
      add :ratings, {:array, :integer}, default: []

      timestamps
    end
    execute "CREATE INDEX idxtags ON recipes USING GIN (tags);"

    # create table(:ancestors) do
    #   add :recipe_id, references(:recipes)
    #   add :ancestor_id, references(:recipes)
      
    #   timestamps
    # end

    create table(:ingredients) do
      add :name, :string
      add :amount, :string
      add :recipe_id, references(:recipes)

      timestamps
    end

    create index(:ingredients, [:name])
  end

  def down do
    drop index(:ingredients, [:name])
    drop table(:ingredients)

    # drop table(:ancestors)

    drop index(:recipes, [:tags], name: "idxtags")
    drop table(:recipes)
  end
end
