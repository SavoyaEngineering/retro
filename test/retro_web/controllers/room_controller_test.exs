defmodule RetroWeb.RetroControllerTest do
  use RetroWeb.ConnCase

  alias Retro.Room

  test "GET /retros", %{conn: conn} do
    Room.create(%Room{name: "Accounting Retro"})
    Room.create(%Room{name: "Dev Retro"})


    conn = get conn, "/rooms"


    response = html_response(conn, 200)
    assert response =~ "Accounting Retro"
    assert response =~ "Dev Retro"
  end
end
