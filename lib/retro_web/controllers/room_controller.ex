defmodule RetroWeb.RoomController do
  #TODO only respond to JSON requests once React routing is figured out
  use RetroWeb, :controller

  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Item}
  alias RetroWeb.Guardian

  def index(conn, _params) do
    case get_format(conn)  do
      "html" ->
        render(conn, "index.html")
      "json" ->
        rooms =
          Repo.all(Room)
          |> Enum.map(fn (room) -> Room.as_json(room) end)
        json(conn, %{rooms: rooms})
    end
  end

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"name" => name, "password" => password}) do
    case %{name: name, password: password}
         |> Room.create do
      {:ok, _model} ->
        conn
        |> put_status(201)
        |> json(%{})
      {:error, changeset} ->
        Enum.map(changeset.errors, &readable_error(&1))
        |> error_response(conn)
    end
  end

  def go_to_room(conn, %{"id" => id, "password" => password}) do
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
        json(conn, %{room_token: get_room_token(room)})
      {:error, _reason, conn} ->
        error_response(["Invalid password"], conn)
    end
  end

  def show(conn, %{"id" => id}) do
    case get_format(conn)  do
      "html" ->
        conn
        |> render("show.html")
      "json" ->
        room = Repo.get(Room, id)
        if room.id === current_room_for_conn(conn) do
          json(
            conn,
            %{
              id: room.id,
              name: room.name,
              socket_token: get_socket_token(conn, room.id),
              items: items_for_room(room),
            }
          )
        else
          error_response(["Invalid token"], conn)
        end
    end
  end

  defp login(conn, room) do
    conn
    |> Guardian.Plug.sign_in(room)
  end

  defp get_room_token(room) do
    {:ok, token, _} = RetroWeb.Guardian.encode_and_sign(room)
    token
  end

  defp get_socket_token(conn, room_id) do
    Phoenix.Token.sign(conn, "room socket", room_id)
  end

  def current_room_for_conn(conn) do
    {id, _} = Integer.parse(Guardian.Plug.current_resource(conn)[:id])
    id
  end

  defp room_not_found(conn) do
    conn
    |> put_flash(:error, "Retro not found")
    |> redirect(to: "/rooms")
  end

  defp items_for_room(room) do
    from(
      item in Item,
      where: item.room_id == ^room.id,
      where: item.archived == false,
      order_by: item.inserted_at
    )
    |> Repo.all()
    |> Enum.map(fn (item) -> Item.as_json(item) end)
  end

  defp readable_error(error) do
    elem(error, 1)
    |> elem(0)
  end

  defp error_response(errors, conn) do
    conn
    |> put_status(422)
    |> json(%{errors: errors})
  end
end
