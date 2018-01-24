defmodule RetroWeb.RetroControllerTest do
  use RetroWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room}

  describe "GET /rooms" do
    test "renders room/index.html", %{conn: conn} do
      Room.create(%{name: "Accounting Retro", password: "bethcatlover"})
      Room.create(%{name: "Dev Retro", password: "bethcatlover"})


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
      params = %{name: "RETRO", password: "bethcatlover"}


      conn = post conn, "/rooms", room: params


      redirect_path = redirected_to(conn)
      assert redirect_path === "/rooms"

      query = from room in "rooms", where: room.name == "RETRO", where: not(is_nil(room.password_hash)), select: room.name
      assert (Repo.all(query) |> Enum.count) == 1
    end

    test "redirects to new with errors when the room is invalid", %{conn: conn} do
      params = %{name: "", password: ""}


      conn = post conn, "/rooms", room: params

      response = html_response(conn, 200)
      assert response =~ "Create a retro"
      assert response =~ "Name required"
      assert response =~ "Password required"
    end
  end

  describe "POST /go_to_room" do
    test "it renders the room show when correct password supplied", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "/rooms/go_to_room/", room: %{id: room.id, password: "bethcatlover"}


      redirect_path = redirected_to(conn)
      assert redirect_path === "/rooms/#{room.id}"
    end

    test "it renders index and sets flash when the password is incorrect", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "/rooms/go_to_room/", room: %{id: room.id, password: "wrong"}

      response = html_response(conn, 200)
      assert response =~ "Select a retro room"
      assert response =~ "Invalid password"
    end
  end

  describe "GET /rooms/:id" do
    test "it lets someone who is logged into the room view the room" do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      #setup the connection signed into that room
      conn = build_conn()
             |> RetroWeb.Guardian.Plug.sign_in(room)


      conn = get conn, "rooms/#{room.id}"


      assert html_response(conn, 200) =~ "Dev Retro"
    end

    test "it redirects to index when someone who is not logged into the room visits" do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok, other_room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      #setup the connection signed into that room
      conn = build_conn()
             |> RetroWeb.Guardian.Plug.sign_in(room)


      conn = get conn, "rooms/#{other_room.id}"

      redirect_path = redirected_to(conn)
      assert redirect_path === "/rooms"
    end
  end
end
