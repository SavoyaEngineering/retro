defmodule Retro.RoomTest do
  use Retro.DataCase
  alias Retro.{Repo, Room}
  doctest Room

  describe "Room.create/1" do
    test "creates a room with a password" do
      Room.create(%{name: "Accounting Retro", password: "super_secure"})


      assert (Repo.all(Room) |> Enum.count) === 1
      room = Repo.one(Room)
      assert room.name === "Accounting Retro"
      assert room.password_hash !== nil
    end

    test "does not create invalid rooms" do
      {:error, room} = Room.create(%{name: ""})


      errors = room.errors
      assert Enum.count(errors) === 2
      assert elem(Enum.at(errors, 0), 1) |> elem(0) === "Password required"
      assert elem(Enum.at(errors, 1), 1) |> elem(0) === "Name required"
      assert (Repo.all(Room) |> Enum.count) === 0
    end

    test "does not create multiple rooms with the same name" do
      Room.create(%{name: "Accounting Retro", password: "super_secure"})
      assert (Repo.all(Room) |> Enum.count) === 1


      {:error, room} = Room.create(%{name: "Accounting Retro", password: "also_super_secure"})
      errors = room.errors
      assert Enum.count(errors) === 1
      assert elem(Enum.at(errors, 0), 1) |> elem(0) === "Name has already been taken"
      assert (Repo.all(Room) |> Enum.count) === 1
    end
  end
end
