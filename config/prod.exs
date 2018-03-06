use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# RetroWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :retro, RetroWeb.Endpoint,
       load_from_system_env: true,
       http: [port: "${PORT}"],
       check_origin: false,
       root: ".",
       cache_static_manifest: "priv/static/cache_manifest.json",
       url: [host: "example.com", port: 80], # This is critical for ensuring web-sockets properly authorize.
       version: Application.spec(:retro, :vsn)

config :retro, RetroWeb.Endpoint,
       server: true,
       secret_key_base: "${SECRET_KEY_BASE}"

# Configure your database
config :retro, Retro.Repo,
       adapter: Ecto.Adapters.Postgres,
       url: "${DATABASE_URL}",
       database: "",
       ssl: true,
       pool_size: 1 #needs to be 1 on free gigalixir teir TODO upgrade?

config :retro, RetroWeb.Guardian,
       issuer: "retro",
       secret_key: "${GUARDIAN_KEY}"

config :sendgrid,
       api_key: System.get_env("SENDGRID_API_KEY")

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :retro, RetroWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :retro, RetroWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :retro, RetroWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
#we are not importing prod.secret.exs as Gigalixir prefers to bring in env variables
#import_config "prod.secret.exs"
