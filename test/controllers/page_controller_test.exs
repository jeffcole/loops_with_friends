defmodule Loops.PageControllerTest do
  use Loops.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Elm.App.fullscreen"
  end
end
