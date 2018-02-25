defmodule RetroWeb.PageController do
  use RetroWeb, :controller

  def index(conn, _params) do
    render conn, "somethingfake.html" #this is just to subvert the phoenix html requests when navigating
  end
end
