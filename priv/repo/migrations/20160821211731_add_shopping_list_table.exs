defmodule Cookbook.Repo.Migrations.AddShoppingListTable do
  use Ecto.Migration

  def change do
    create table(:shopping_lists) do
      add :recipe_id, references(:recipes)
      add :user_id, references(:users)

      timestamps
    end

    create index(:shopping_lists, [:recipe_id, :user_id], unique: true)
  end
end
