defmodule RetroWeb.RoomChannel do
  use Phoenix.Channel

  alias Retro.{Repo, Item}

  def join("room:" <> _private_room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in(msg_type, %{"body" => body, "room_id" => room_id}, socket) do
    {:ok, item} = Item.create(%{text: body, type: msg_type, room_id: room_id})
    broadcast!(socket, "new_msg", %{id: item.id, text: item.text, type: item.type, thumbs_up_count: 0})
    {:noreply, socket}
  end

  def handle_in("select_item" = action, %{"item_id" => id}, socket) do
    broadcast_item_change(action, id, socket)
  end

  def handle_in("archive_item" = action, %{"item_id" => id}, socket) do
    if item = Repo.get(Item, id) do
      Item.archive(item)
    end

    broadcast_item_change(action, id, socket)
  end

  def handle_in("thumbs_up" = action, %{"item_id" => id}, socket) do
    if item = Repo.get(Item, id) do
      Item.changeset(item, %{thumbs_up_count: item.thumbs_up_count + 1})
      |> Repo.update
    end

    broadcast_item_change(action, id, socket)
  end

  defp broadcast_item_change(action, id, socket) do
    broadcast!(socket, action, %{item_id: id})
    {:noreply, socket}
  end
end