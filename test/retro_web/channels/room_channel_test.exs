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

  test "broadcasts to room:room_id", %{socket: socket} do
    push socket, "happy_msg", %{"body" => "JH: some retro item", "room_id" => 123}


    assert_receive %Phoenix.Socket.Broadcast{
      topic: "room:123",
      event: "happy_msg",
      payload: %{body: "JH: some retro item"}}
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
