defmodule Cookbook.Repo.Migrations.UpdateRecipeTableWithLongerInstructions do
  use Ecto.Migration

  def up do
    alter table(:recipes) do
      modify :instructions, :string, size: 1000
    end
  end

  def down do
    alter table(:recipes) do
      modify :instructions, :string, size: 255
    end
  end
end
