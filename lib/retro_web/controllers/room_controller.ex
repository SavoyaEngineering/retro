defmodule RetroWeb.RoomController do
  use RetroWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
