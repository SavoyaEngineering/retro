defmodule RetroWeb.RetroControllerTest do
  use RetroWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Item}

  describe "GET /rooms" do
    test "renders room/index.html", %{conn: conn} do
      conn = get conn, "/rooms"


      html_response(conn, 200)
    end

    test "when request for JSON it returns a list of rooms", %{conn: conn} do
      {:ok, room1} = Room.create(%{name: "Accounting Retro", password: "bethcatlover"})
      {:ok, room2} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = get conn, "api/rooms"


      assert json_response(conn, 200) == %{
               "rooms" => [%{"id" => room1.id, "name" => "Accounting Retro"}, %{"id" => room2.id, "name" => "Dev Retro"}]
             }
    end
  end

  describe "GET /rooms/new" do
    test "renders room/new.html", %{conn: conn} do
      conn = get conn, "/rooms/new"


      html_response(conn, 200)
    end
  end

  describe "POST /rooms" do
    test "it responds to JSON and creates a room", %{conn: conn} do
      params = %{name: "RETRO", password: "bethcatlover"}


      conn = post conn, "api/rooms", params


      assert json_response(conn, 201) == %{}
      query = from room in "rooms", where: room.name == "RETRO", where: not(is_nil(room.password_hash)), select: room.name
      assert (Repo.all(query) |> Enum.count) == 1
    end

    test "returns an error response when it cannot create a room", %{conn: conn} do
      params = %{name: "RETRO", password: ""}


      conn = post conn, "api/rooms", params


      assert json_response(conn, 422) == %{"errors" => ["Password required"]}
      query = from room in "rooms", where: room.name == "RETRO", where: not(is_nil(room.password_hash)), select: room.name
      assert (Repo.all(query) |> Enum.count) == 0
    end
  end

  describe "POST /go_to_room" do
    test "it renders the room show when correct password supplied", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "api/rooms/go_to_room/", %{id: room.id, password: "bethcatlover"}


      response  = json_response(conn, 200)
      assert response["room_token"] != nil
    end


    test "it renders index and sets flash when the password is incorrect", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "api/rooms/go_to_room/", %{id: room.id, password: "wrong"}


      assert json_response(conn, 422) == %{"errors" => ["Invalid password"]}
    end
  end

  describe "GET /rooms/:id" do
    test "it loads show.html when request is for html", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = get conn, "rooms/#{room.id}"


      html_response(conn, 200)
    end

    test "it loads data for the room when the request is for JSON", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})

      Item.create(%{room_id: room.id, type: "happy_msg", text: "JH - foosball table", archived: false})
      Item.create(%{room_id: room.id, type: "happy_msg", text: "JH - archived", archived: true})

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = get conn, "api/rooms/#{room.id}"


      response = json_response(conn, 200)
      assert response["name"] === "Dev Retro"
      assert response["socket_token"] !== nil
      assert Enum.count(response["items"]) === 1
    end

    test "sends error response when room token is bad", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok, other_room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})

      #setup the connection signed into that room
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: wrong")


      conn = get conn, "api/rooms/#{other_room.id}"


      response(conn, 401)
    end

    test "sends error response when room token is for the wrong room", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok, other_room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = get conn, "api/rooms/#{other_room.id}"


      json_response(conn, 422) === %{"errors" => ["Invalid token"]}
    end
  end
end
