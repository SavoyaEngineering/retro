defmodule RetroWeb.PageControllerTest do
  use RetroWeb.ConnCase

  describe "GET /" do
    test "it renders text on the page", %{conn: conn} do
      conn = get conn, "/"


      assert html_response(conn, 200) =~ "Start or join a retro"
    end
  end
end
