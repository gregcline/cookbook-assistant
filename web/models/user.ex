defmodule Cookbook.User do
  use Cookbook.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: :true
    field :password_hash, :string
    has_many :recipe_books, Cookbook.RecipeBook
    has_many :shopping_lists, Cookbook.ShoppingList

    timestamps
  end

  @login_params ~w(password username)a
  @register_params ~w(email name)a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @login_params)
    |> validate_required(@login_params)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, @register_params)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 1, max: 20)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end