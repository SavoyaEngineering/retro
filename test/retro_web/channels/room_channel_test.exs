defmodule RetroWeb.RoomChannelTest do
  use RetroWeb.ChannelCase

  alias RetroWeb.RoomChannel
  alias Retro.{Repo, Item}

  setup do
    {:ok, _, socket} =
      socket("room_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:123")

    {:ok, socket: socket}
  end

  describe "when receiving a create message" do
    test "broadcasts to room:room_id", %{socket: socket} do
      push socket, "happy_msg", %{"body" => "JH: some retro item", "room_id" => 123}

      assert_receive %Phoenix.Socket.Broadcast{
        topic: "room:123",
        event: "new_msg",
        payload: %{text: "JH: some retro item", id: _, type: "happy_msg"}}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from! socket, "happy_msg", %{"body" => "JH: some retro item", "room_id" => 123}


      assert_push "happy_msg", %{"body" => "JH: some retro item", "room_id" => 123}
    end

    test "creates a new item", %{socket: socket} do
      push socket, "happy_msg", %{"body" => "JH: some retro item", "room_id" => 123}


      Process.sleep(10) #this sleep has to be here as the process is async and takes some amount of time
      assert (Repo.all(Item) |> Enum.count) == 1
    end
  end

  describe "when action is select_item" do
    test "broadcasts to room:room_id", %{socket: socket} do
      push socket, "select_item", %{"item_id" => 321}


      assert_receive %Phoenix.Socket.Broadcast{
        topic: "room:123",
        event: "select_item",
        payload: %{item_id: 321}}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from! socket, "select_item", %{"item_id" => 321}


      assert_push "select_item", %{"item_id" => 321}
    end
  end

  describe "when action is archive_item" do
    test "broadcasts to room:room_id", %{socket: socket} do
      push socket, "archive_item", %{"item_id" => 321}


      assert_receive %Phoenix.Socket.Broadcast{
        topic: "room:123",
        event: "archive_item",
        payload: %{item_id: 321}}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from! socket, "archive_item", %{"item_id" => 321}


      assert_push "archive_item", %{"item_id" => 321}
    end

    test "archives the item", %{socket: socket} do
      {:ok, item} = Item.create(%{text: "JH: New retro app.", type: "happy_msg", room_id: 12, archived: false})


      broadcast_from! socket, "archive_item", %{"item_id" => item.id}
      push socket, "archive_item", %{"item_id" => item.id}


      Process.sleep(10) #this sleep has to be here as the process is async and takes some amount of time
      updated_item = Repo.get(Item, item.id)
      assert updated_item.archived === true
    end
  end

  describe "when action is thumbs_up" do
    test "broadcasts to room:room_id", %{socket: socket} do
      push socket, "thumbs_up", %{"item_id" => 321}


      assert_receive %Phoenix.Socket.Broadcast{
        topic: "room:123",
        event: "thumbs_up",
        payload: %{item_id: 321}}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from! socket, "thumbs_up", %{"item_id" => 321}

      assert_push "thumbs_up", %{"item_id" => 321}
    end

    test "adds to thumbs_up_count do", %{socket: socket} do
      {:ok, item} = Item.create(%{text: "JH: New retro app.", type: "happy_msg", room_id: 12, thumbs_up_count: 0})


      broadcast_from! socket, "thumbs_up", %{"item_id" => item.id}
      push socket, "thumbs_up", %{"item_id" => item.id}


      Process.sleep(10) #this sleep has to be here as the process is async and takes some amount of time
      updated_item = Repo.get(Item, item.id)
      assert updated_item.thumbs_up_count === 1
    end
  end
end
