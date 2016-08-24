defmodule LoopsWithFriends.PageController do
  use LoopsWithFriends.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
