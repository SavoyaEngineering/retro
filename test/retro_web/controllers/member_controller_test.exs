defmodule RetroWeb.MemberControllerTest do
  use RetroWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Member}

  describe "GET /rooms/:id/members" do
    test "it gets the members for a room", %{conn: conn} do
      {:ok, room1} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok, room2} = Room.create(%{name: "Dev Retro2", password: "bethcatlover"})
      {:ok, member} = Repo.insert(Member.changeset(%Member{email: "member@ex.com", room_id: room1.id}))
      Repo.insert(Member.changeset(%Member{email: "for_other_room@ex.com", room_id: room2.id}))

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room1)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = get conn, "api/rooms/#{room1.id}/members"


      response = json_response(conn, 200)
      assert Enum.count(response["members"]) == 1
      [member_response| _ ]= response["members"]
      assert member_response["id"] == member.id
      assert member_response["email"] == "member@ex.com"
    end
  end

  describe "POST /rooms/:id/members/invite" do
    test "it sends email invite to list of recipients and creates members", %{conn: conn} do
      {:ok, room} = Room.create(%{name: "Dev Retro", password: "bethcatlover"})

      #setup the connection signed into that room
      {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
      conn = conn
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "Bearer: #{token}")


      conn = post conn, "api/rooms/#{room.id}/members/invite", %{emails: "fake@example.com, fake2@example.com"}


      reloaded_room = Repo.get(Room, room.id)
      {:ok, _} = Phoenix.Token.verify(conn, "room socket", reloaded_room.temporary_token, max_age: 1209600)

      query = from member in "members", where: member.room_id == ^room.id, select: member.email
      assert Repo.all(query) == ["fake2@example.com", "fake@example.com"]
      #TODO test the email was sent, Jose says no stubs.
    end
  end
end
