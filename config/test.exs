use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :retro, RetroWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :retro, Retro.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "retro_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :retro, RetroWeb.Guardian,
       issuer: "retro",
       secret_key: "secret"

config :sendgrid,
       api_key: "fake_key"

