defmodule RetroWeb.Router do
  use RetroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authorized do
    plug Guardian.Plug.Pipeline,
         module: RetroWeb.Guardian,
         error_handler: RetroWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :unauthorized do
    plug :fetch_session
  end


#   Other scopes may use custom stacks.
  scope "/api", RetroWeb do
    pipe_through :api
    resources "/rooms", RoomController, only: [:index, :create]
    post "/rooms/go_to_room", RoomController, :go_to_room

    scope "/" do
      pipe_through :api_authorized
      resources "/rooms", RoomController, only: [:show]
    end
  end

  scope "/", RetroWeb do
    pipe_through :browser # Use the default browser stack

    scope "/" do
      pipe_through :unauthorized
      get "/*path", PageController, :index #tell phoenix html requests to go here and die
    end
  end
end
