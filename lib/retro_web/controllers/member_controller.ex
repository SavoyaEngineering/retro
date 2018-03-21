defmodule RetroWeb.MemberController do
  use RetroWeb, :controller

  alias Retro.{Repo, Room, Member, Mailer}
  alias RetroWeb.AuthHelper

  def index(conn, %{"room_id" => room_id}) do
    room = Repo.get(Room, room_id)

    if room.id === AuthHelper.current_room_for_conn(conn) do
      json = (from member in Member, where: member.room_id == ^room.id)
             |> Repo.all
             |> Enum.map(&Member.as_json(&1))

      json(conn, %{members: json})
    else
      error_response(["Invalid token"], conn)
    end
  end

  def invite(conn, %{"emails" => email_string, "room_id" => room_id}) do
    room = Repo.get(Room, room_id)
    if room.id === AuthHelper.current_room_for_conn(conn) do
      token = AuthHelper.get_socket_token(conn, room.id)
      changeset = Ecto.Changeset.change room, temporary_token: token
      Repo.update(changeset)

      emails =
        String.split(email_string, ",")
        |> Enum.map(&String.trim(&1))

      Member.add_members(room, emails)

      Mailer.send_join_room_email(emails, token)
      json(conn, %{})
    else
      error_response(["Invalid token"], conn)
    end
  end

  def delete(conn, %{"id" => member_id, "room_id" => room_id}) do
    room = Repo.get(Room, room_id)
    if room.id === AuthHelper.current_room_for_conn(conn) do
      member = Repo.get!(Member, member_id)
      Repo.delete(member)
      json(conn, %{})
    else
      error_response(["Invalid token"], conn)
    end
  end
end
