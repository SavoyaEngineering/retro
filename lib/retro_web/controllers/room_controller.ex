defmodule RetroWeb.RoomController do
  use RetroWeb, :controller

  alias Retro.{Repo, Room}

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
    room_params = params["room"]
    case %{name: room_params["name"], password: room_params["password"]}
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

  def show(conn, params) do
    conn
      |> assign(:room, Repo.get(Room, params["id"]))
      |> render("show.html")
  end
end
