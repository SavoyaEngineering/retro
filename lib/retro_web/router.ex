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
    plug Guardian.Plug.Pipeline, module: RetroWeb.Guardian,
                                 error_handler: RetroWeb.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
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

  # Other scopes may use custom stacks.
  # scope "/api", RetroWeb do
  #   pipe_through :api
  # end
end
