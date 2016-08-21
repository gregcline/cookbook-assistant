defmodule Cookbook.PageController do
  use Cookbook.Web, :controller
  alias Cookbook.Recipe
  alias Cookbook.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    recipes = Repo.all(top_ten)
    render conn, "index.html", recipes: recipes
  end

  def top_ten do
    from r in Recipe,
      limit: 10,
      order_by: [desc: :inserted_at]
  end
end
