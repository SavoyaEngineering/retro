defmodule Retro.RoomTest do
  use Retro.DataCase
  alias Retro.{Repo, Room}
  doctest Room

  describe "Room.create/1" do
    test "creates a room" do
      assert (Repo.all(Room) |> Enum.count) == 0


      Room.create(%Room{name: "Accounting Retro"})


      assert (Repo.all(Room) |> Enum.count) == 1
    end
  end
end
