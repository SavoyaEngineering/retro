defmodule RetroWeb.RoomController do
  use RetroWeb, :controller

  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Item, Mailer}
  alias RetroWeb.Guardian

  def create(conn, %{"name" => name, "password" => password}) do
    case %{name: name, password: password}
         |> Room.create do
      {:ok, room} ->
        conn
        |> put_status(201)
        |> json(go_to_room_response(room))
      {:error, changeset} ->
        Enum.map(changeset.errors, &readable_error(&1))
        |> error_response(conn)
    end
  end

  def go_to_room(conn, %{"name" => name, "password" => password}) do
    room = Repo.get_by(Room, name: name)

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
        json(conn, go_to_room_response(room))
      {:error, _reason, conn} ->
        error_response(["Invalid credentials"], conn)
    end
  end

  def go_to_room_with_token(conn, %{"temporary_token" => token}) do
    room = if token != nil do
      Repo.get_by(Room, temporary_token: token)
    end

    if room do
      login(conn, room)
      |> json(go_to_room_response(room))
    else
      error_response(["Invalid credentials"], conn)
    end
  end

  def show(conn, %{"id" => id}) do
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

  def invite(conn, %{"emails" => email_string, "id" => id}) do
    room = Repo.get(Room, id)
    if room.id === current_room_for_conn(conn) do
      token = get_socket_token(conn, room.id)
      room = Ecto.Changeset.change room, temporary_token: token
      Repo.update room
      Mailer.send_join_room_email(email_string, token)
      json(conn, %{})
    else
      error_response(["Invalid token"], conn)
    end
  end

  defp login(conn, room) do
    conn
    |> Guardian.Plug.sign_in(room)
  end

  defp go_to_room_response(room) do
    %{room_token: get_room_token(room), room_id: room.id}
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
