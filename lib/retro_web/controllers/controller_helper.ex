defmodule RetroWeb.ControllerHelper do
  import Plug.Conn
  import Phoenix.Controller

  def error_response(errors, conn) do
    conn
    |> put_status(422)
    |> json(%{errors: errors})
  end

end