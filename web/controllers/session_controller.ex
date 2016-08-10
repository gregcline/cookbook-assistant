defmodule Cookbook.SessionController do
  @moduledoc """
  Handles creating new sessions and dropping sessions.
  """
  use Cookbook.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end