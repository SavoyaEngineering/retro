defmodule Retro.ItemTest do
  use Retro.DataCase
  alias Retro.{Repo, Item}
  doctest Item

  describe "Item.create/1" do
    test "creates a room with a password" do
      Item.create(%{text: "JH: New retro app.", type: "happy_msg", room_id: 12})


      assert (Repo.all(Item) |> Enum.count) === 1
      item = Repo.one(Item)
      assert item.text === "JH: New retro app."
      assert item.type === "happy_msg"
      assert item.room_id === 12
    end

    test "does not create invalid rooms" do
      {:error, item} = Item.create(%{text: ""})


      errors = item.errors
      assert Enum.count(errors) === 3
      assert elem(Enum.at(errors, 0), 1) |> elem(0) === "Type required"
      assert elem(Enum.at(errors, 1), 1) |> elem(0) === "Text required"
      assert elem(Enum.at(errors, 2), 1) |> elem(0) === "Room ID required"
      assert (Repo.all(Item) |> Enum.count) === 0
    end
  end

  describe "Item.archive/1" do
    test "archives a given item" do
      {:ok, item} = Item.create(%{text: "JH: New retro app.", type: "happy_msg", room_id: 12, archived: false})


      Item.archive(item)


      updated_item = Repo.get(Item, item.id)
      assert updated_item.archived === true
    end
  end
end
