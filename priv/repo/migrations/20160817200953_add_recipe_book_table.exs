defmodule Cookbook.Repo.Migrations.AddRecipeBookTable do
  use Ecto.Migration

  def change do
    create table(:recipe_books) do
      add :recipe_id, references(:recipes)
      add :user_id, references(:users)

      timestamps
    end

    create index(:recipe_books, [:recipe_id, :user_id], unique: true)
  end
end
