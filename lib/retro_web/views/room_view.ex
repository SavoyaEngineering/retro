defmodule RetroWeb.RoomView do
  use RetroWeb, :view

  alias Retro.{Repo, Room}

  def rooms do
    Repo.all(Room)
    |> Enum.map(fn (room) -> encode(room) end)
  end

  def room_changeset(room) do
    %Room{name: room.name}
    |> Room.changeset
  end

  def readable_error(error) do
    elem(error, 1)
    |> elem(0)
  end

  defp encode(room) do
    %{
      id: room.id,
      name: room.name
    }
  end
end
