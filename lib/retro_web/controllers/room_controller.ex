defmodule RetroWeb.RoomController do
  use RetroWeb, :controller

  alias Retro.Room

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:errors, false)
    |> assign(:changeset, Room.changeset(%Room{}))
    |> render("new.html")
  end

  def create(conn, params) do
    case %Room{name: params["room"]["name"]}
          |> Room.create do
      {:ok, _model} ->
        redirect(conn, to: "/rooms")
      {:error, changeset} ->
        conn
        |> assign(:errors, true)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
