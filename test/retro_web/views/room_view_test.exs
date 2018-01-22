defmodule RetroWeb.RoomViewTest do
  use RetroWeb.ConnCase, async: true

  alias RetroWeb.RoomView
  alias Retro.Room

  describe "RoomView.rooms/0" do
    test "returns all serialized rooms" do
      {:ok, retro1} = Room.create(%Room{name: "Accounting Retro"})
      {:ok, retro2} = Room.create(%Room{name: "Dev Retro"})
      expected = [
        %{:id => retro1.id, :name => "Accounting Retro"},
        %{:id => retro2.id, :name => "Dev Retro"}
      ]


      result = RoomView.rooms


      assert result === expected
    end
  end
end
