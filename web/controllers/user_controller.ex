defmodule Cookbook.UserController do
  @moduledoc """
  Handles creating new users
  """
  use Cookbook.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end