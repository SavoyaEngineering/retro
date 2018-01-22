defmodule RetroWeb.RoomView do
  use RetroWeb, :view

  alias Retro.{Repo, Room}

  def rooms do
    Repo.all(Room)
    |> Enum.map(fn (room) -> encode(room) end)
  end

  defp encode(room) do
    %{
      id: room.id,
      name: room.name
    }
  end
end
