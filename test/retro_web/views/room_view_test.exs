defmodule RetroWeb.RoomViewTest do
  use RetroWeb.ConnCase, async: true

  alias RetroWeb.RoomView
  alias Retro.Room

  describe "RoomView.rooms/0" do
    test "returns all serialized rooms" do
      {:ok, retro1} = Room.create(%{name: "Accounting Retro", password: "something"})
      {:ok, retro2} = Room.create(%{name: "Dev Retro"})
      expected = [
        %{:id => retro1.id, :name => "Accounting Retro", password_required: true},
        %{:id => retro2.id, :name => "Dev Retro", password_required: false}
      ]


      result = RoomView.rooms


      assert result === expected
    end
  end

  describe "RoomView.readable_error/1" do
    test "it returns the error message" do
      assert RoomView.readable_error({:error, {"readable error", "other thing"}}) === "readable error"
    end
  end
end
