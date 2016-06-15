defmodule Loops.PageController do
  use Loops.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
