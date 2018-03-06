# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :retro,
  ecto_repos: [Retro.Repo]

config :mime, :types, %{
  "application/json" => ["json"]
}

# Configures the endpoint
config :retro, RetroWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QnmvbvsilYyCzVdXsw4r2+feJuC05zqNVc0oh1Ul5prVQ1zJfX0N4LeErOCyWpHc",
  render_errors: [view: RetroWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Retro.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sendgrid,
       api_key: System.get_env("SENDGRID_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
