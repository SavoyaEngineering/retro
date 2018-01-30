defmodule RetroWeb.RoomController do
  use RetroWeb, :controller

  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Item}
  alias RetroWeb.Guardian

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:errors, false)
    |> assign(:changeset, Room.changeset(%Room{}))
    |> render("new.html")
  end

  def create(conn, %{"room" => %{"name" => name, "password" => password}}) do
    case %{name: name, password: password}
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

  def go_to_room(conn, %{"room" => %{"id" => id, "password" => password}}) do
    room = Repo.get(Room, id)

    result = cond do
      room && checkpw(password, room.password_hash) ->
        {:ok, login(conn, room)}
      room ->
        {:error, :unauthorized, conn}
      true ->
        # simulate check password hash timing
        dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You have joined the retro")
        |> assign(:room, room)
        |> redirect(to: "/rooms/#{room.id}")
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid password")
        |> render("index.html")
    end
  end

  def show(conn, %{"id" => id}) do
    room = Repo.get(Room, id)

    if room do
      authenticated_room_id = Guardian.Plug.current_resource(conn)[:id]
      if id == authenticated_room_id  do
        conn
        |> assign(:room, room)
        |> assign(:happy_items, items_for_room(room, "happy_msg"))
        |> assign(:middle_items, items_for_room(room, "middle_msg"))
        |> assign(:sad_items, items_for_room(room, "sad_msg"))
        |> render("show.html")
      else
        room_not_found(conn)
      end
    else
      room_not_found(conn)
    end
  end

  defp login(conn, room) do
    conn
    |> Guardian.Plug.sign_in(room)
  end

  defp room_not_found(conn) do
    conn
    |> put_flash(:error, "Retro not found")
    |> redirect(to: "/rooms")
  end

  defp items_for_room(room, item_type) do
    from(
      item in Item,
      where: item.type == ^item_type,
      where: item.room_id == ^room.id,
      where: item.archived == false,
      order_by: item.inserted_at
    )
    |> Repo.all()
  end
end
