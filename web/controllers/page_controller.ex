defmodule Cookbook.PageController do
  use Cookbook.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
