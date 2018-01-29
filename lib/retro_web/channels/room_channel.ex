defmodule RetroWeb.RoomChannel do
  use Phoenix.Channel

  alias Retro.Item

  def join("room:" <> _private_room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in(msg_type, %{"body" => body, "room_id" => room_id}, socket) do
    Item.create(%{text: body, type: msg_type, room_id: room_id})
    broadcast!(socket, msg_type, %{body: body})
    {:noreply, socket}
  end
end