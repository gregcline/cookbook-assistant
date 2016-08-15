defmodule Cookbook.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string, size: 20
      add :email, :string
      add :password_hash, :string, size: 100
      
      timestamps
    end

    create index(:users, [:username], unique: true)
    create index(:users, [:email], unique: true)
  end
end
