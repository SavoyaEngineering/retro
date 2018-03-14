defmodule RetroWeb.RoomControllerTest do
  use RetroWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Item}

  describe "POST /rooms" do
    test "it responds to JSON and creates a room", %{conn: conn} do
      params = %{name: "RETRO", password: "bethcatlover"}


      conn = post conn, "api/rooms", params


      query = from room in "rooms", where: room.name == "RETRO", where: not(is_nil(room.password_hash)), select: room.id
      assert (Repo.all(query) |> Enum.count) == 1
      room_id = Repo.one(query)
      response  = json_response(conn, 201)
      assert response["room_token"] != nil
      assert response["room_id"] == room_id
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


      conn = post conn, "api/rooms/go_to_room/", %{name: "Dev Retro", password: "bethcatlover"}


      response  = json_response(conn, 200)
      assert response["room_token"] != nil
      assert response["room_id"] == room.id
    end

    test "it returns error when password is invalid", %{conn: conn} do
      {:ok, _room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "api/rooms/go_to_room/", %{name: "Dev Retro", password: "wrong"}


      assert json_response(conn, 422) == %{"errors" => ["Invalid credentials"]}
    end

    test "it returns error when no room is found", %{conn: conn} do
      {:ok, _room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})


      conn = post conn, "api/rooms/go_to_room/", %{name: "Wrong room", password: "bethcatlover"}


      assert json_response(conn, 422) == %{"errors" => ["Invalid credentials"]}
    end
  end

  describe "POST /join_room_with_token" do
    test "responds with the login info when a matching temporary_token is provided", %{conn: conn} do
      {:ok, room} = Room.create(
        %{name: "Dev Retro", password: "bethcatlover", temporary_token: "tok_123"}
      )


      conn = post conn, "api/rooms/go_to_room_with_token/", %{temporary_token: "tok_123"}


      response  = json_response(conn, 200)
      assert response["room_token"] != nil
      assert response["room_id"] == room.id
    end

    test "responds with errors when a non-matching temporary_token is provided", %{conn: conn} do
      {:ok, _room} = Room.create(
        %{name: "Dev Retro", password: "bethcatlover", temporary_token: "tok_123"}
      )


      conn = post conn, "api/rooms/go_to_room_with_token/", %{temporary_token: "tok_122"}


      assert json_response(conn, 422) == %{"errors" => ["Invalid credentials"]}
    end

    test "responds with errors when a nil temporary_token is provided", %{conn: conn} do
      {:ok, _room} = Room.create(
        %{name: "Dev Retro", password: "bethcatlover", temporary_token: nil}
      )


      conn = post conn, "api/rooms/go_to_room_with_token/", %{temporary_token: nil}


      assert json_response(conn, 422) == %{"errors" => ["Invalid credentials"]}
    end
  end

  describe "GET /rooms/:id" do
    test "it loads data for the room", %{conn: conn} do
      {:ok, room} = Room.create(
        %{name: "Dev Retro", password: "bethcatlover", retro_day: "Friday", retro_time: "1100"}
      )

      Item.create(%{room_id: room.id, type: "happy_msg", text: "JH - foosball table", archived: false})
      Item.create(%{room_id: room.id, type: "happy_msg", text: "JH - archived", archived: true})

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = get conn, "api/rooms/#{room.id}"


      response = json_response(conn, 200)
      room_response = response["room"]
      assert room_response["id"] === room.id
      assert room_response["name"] === "Dev Retro"
      assert room_response["retro_time"] === "1100"
      assert room_response["retro_day"] === "Friday"
      assert room_response["socket_token"] !== nil
      assert Enum.count(room_response["items"]) === 1
    end

    test "sends error response when room token is for the wrong room", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok, other_room} = Room.create(%{name: "Other Dev Retro", password: "bethcatlover"})

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = get conn, "api/rooms/#{other_room.id}"


      assert json_response(conn, 422) === %{"errors" => ["Invalid token"]}
    end
  end

  describe "PUT /rooms/:id" do
    test "it can update retro_day and retro_time", %{conn: conn} do
      {:ok, room} = Room.create(
        %{name: "Dev Retro", password: "bethcatlover", retro_day: "Friday", retro_time: "1100"}
      )

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = put conn, "api/rooms/#{room.id}", %{retro_day: "Saturday", retro_time: "1200", name: "can't update"}


      response = json_response(conn, 200)
      room_response = response["room"]
      assert room_response["id"] === room.id
      assert room_response["name"] === "Dev Retro"
      assert room_response["retro_time"] === "1200"
      assert room_response["retro_day"] === "Saturday"
    end
  end
end
