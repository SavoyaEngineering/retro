defmodule RetroWeb.RetroControllerTest do
  use RetroWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room}

  describe "GET /rooms" do
    test "renders room/index.html", %{conn: conn} do
      Room.create(%Room{name: "Accounting Retro"})
      Room.create(%Room{name: "Dev Retro"})


      conn = get conn, "/rooms"


      response = html_response(conn, 200)
      assert response =~ "Accounting Retro"
      assert response =~ "Dev Retro"
    end
  end

  describe "GET /rooms/new" do
    test "renders room/new.html", %{conn: conn} do
      conn = get conn, "/rooms/new"


      response = html_response(conn, 200)
      assert response =~ "Create a retro"
    end
  end

  describe "POST /rooms" do
    test "creates a room when the room is valid and redirects to index", %{conn: conn} do
      params = %{name: "RETRO"}
      conn = post conn, "/rooms", room: params


      redirect_path = redirected_to(conn)
      assert redirect_path === "/rooms"

      query = from room in "rooms", where: room.name == "RETRO", select: room.name
      assert (Repo.all(query) |> Enum.count) == 1
    end

    test "redirects to new with errors when the room is invalid", %{conn: conn} do
      params = %{name: nil}
      conn = post conn, "/rooms", room: params


      response = html_response(conn, 200)
      assert response =~ "Create a retro"
      assert response =~ "Name required"
    end
  end
end
