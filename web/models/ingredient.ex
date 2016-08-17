defmodule Cookbook.Ingredient do
  use Cookbook.Web, :model

  schema "ingredients" do
    field :name, :string
    field :amount, :string
    belongs_to :recipe, Recipe

    timestamps
  end

  def changeset(model, params) do
    model
    |> cast(params, ~w(name amount)a)
    |> validate_required(~w(name amount)a, message: "Please insert an ingredient and amount")
  end
end