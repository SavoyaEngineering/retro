defmodule Retro.MemberTest do
  use Retro.DataCase
  alias Retro.{Repo, Member, Room}
  import Ecto.Query, only: [from: 2]
  doctest Member

  describe "Member.add_members/2" do
    test "creates members for a room skipping emails that already exist for that room" do
      {:ok , room1 } = Room.create(%{name: "Dev Retro", password: "bethcatlover"})
      {:ok , room2 } = Room.create(%{name: "Dev Retro2", password: "bethcatlover"})
      Repo.insert(Member.changeset(%Member{email: "already_exists@ex.com", room_id: room1.id}))
      Repo.insert(Member.changeset(%Member{email: "for_other_room@ex.com", room_id: room2.id}))


      Member.add_members(room1, ["already_exists@ex.com", "for_other_room@ex.com", "new@ex.com"])


      assert Repo.all(Member) |> Enum.count == 4
      room1_query = from member in "members", where: member.room_id == ^room1.id, select: member.email
      assert Repo.all(room1_query) == ["new@ex.com", "for_other_room@ex.com", "already_exists@ex.com"]
    end
  end
end
