defmodule Cookbook.Recipe do
  use Cookbook.Web, :model
  alias Cookbook.Ingredient

  schema "recipes" do
    field :name, :string
    field :ingredients_string, :string, virtual: true
    field :tags_string, :string, virtual: true
    has_many :ingredients, Ingredient
    field :instructions, :string
    field :tags, {:array, :string}
    field :ratings, {:array, :integer}

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name instructions ingredients_string)a)
    |> validate_required(~w(name instructions ingredients_string)a)
  end

  def new_recipe_changeset(model, params) do
    model
    |> changeset(params)
    |> add_ingredients(params)
    |> add_rating(params)
    |> add_tags(params)
  end

  defp add_ingredients(changeset, %{"ingredients_string" => ingredients_string}) do
    ingredients_changesets = parse_ingredients(ingredients_string)
    valid_length = length(Enum.take_while(ingredients_changesets, fn changeset -> changeset.valid? end))
    all_length = length(ingredients_changesets)
    cond do
        valid_length == all_length ->
          changeset
          |> Ecto.Changeset.put_assoc(:ingredients, ingredients_changesets)
        true ->
          changeset
          |> Ecto.Changeset.put_assoc(:ingredients, ingredients_changesets)
          |> Ecto.Changeset.add_error(:ingredients_string, "Please insert pairs of ingredients and amounts")
      end
  end


  def parse_ingredients(ingredients_string) do
    ingredients_string
    |> String.split(";", trim: true)
    |> Enum.map(fn ingredient ->
      case String.split(ingredient, ",", trim: true) do
        [name, amount] ->
          changeset = Ingredient.changeset(%Ingredient{}, %{"name" => name, "amount" => amount})
        _ ->
          Ingredient.changeset(%Ingredient{}, %{})
          |> add_error(:name, "Please insert an ingredient and amount")
          |> add_error(:amount, "Please insert an ingredient and amount")
      end
      end)
  end

  defp add_tags(changeset, %{"tags_string" => tags_string}) do
    changeset
    |> Ecto.Changeset.put_change(:tags, parse_tags(tags_string))
  end
  defp add_tags(changeset, _params), do: changeset

  defp parse_tags(tags_string) do
    tags_string
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim(&1))
  end

  defp add_rating(changeset, %{"ratings" => ""}) do
    changeset
    |> Ecto.Changeset.put_change(:ratings, [])
  end
  defp add_rating(changeset, %{"ratings" => rating}) do
    new_rating = case Ecto.Changeset.fetch_field(changeset, :ratings) do
      {_, nil} ->
        [String.to_integer(rating)]
      {:changes, old_rating} ->
        [String.to_integer(rating) | old_rating]
      {:data, old_rating} ->
        [String.to_integer(rating) | old_rating]
      :error ->
        [String.to_integer(rating)]
    end
    changeset
    |> Ecto.Changeset.put_change(:ratings, new_rating)
  end
end