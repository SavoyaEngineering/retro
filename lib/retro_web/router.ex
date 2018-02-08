defmodule RetroWeb.Router do
  use RetroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :unauthorized do
    plug :fetch_session
  end

  pipeline :authorized do
    plug :fetch_session
    plug Guardian.Plug.Pipeline,
         module: RetroWeb.Guardian,
         error_handler: RetroWeb.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug :put_room_token
  end

  defp put_room_token(conn, _) do
    if current_room_id = conn.private.guardian_default_resource[:id] do
      token = Phoenix.Token.sign(conn, "room socket", current_room_id)
      assign(conn, :room_token, token)
    else
      conn
    end
  end


  scope "/", RetroWeb do
    pipe_through :browser # Use the default browser stack

    scope "/" do
      pipe_through :unauthorized

      get "/", PageController, :index

      resources "/rooms", RoomController, only: [:index, :create, :new]
      post "/rooms/go_to_room", RoomController, :go_to_room
    end

    scope "/" do
      pipe_through :authorized
      resources "/rooms", RoomController, only: [:show]
    end
  end

#   Other scopes may use custom stacks.
   scope "/api", RetroWeb do
     pipe_through :api

     resources "/rooms", RoomController, only: [:index, :create, :new]
   end
end
