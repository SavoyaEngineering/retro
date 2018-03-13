defmodule RetroWeb.AuthHelper do
  def current_room_for_conn(conn) do
    {id, _} = Integer.parse(Guardian.Plug.current_resource(conn)[:id])
    id
  end

  def get_socket_token(conn, room_id) do
    Phoenix.Token.sign(conn, "room socket", room_id)
  end
end
