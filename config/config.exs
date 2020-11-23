# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :agileparking,
  ecto_repos: [Agileparking.Repo]

# Configures the endpoint
config :agileparking, AgileparkingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rXe4haxpLB+IWtdLYVWMwD3INID1bbOEic9H8B2h+az06AZaba5mOHuixh3SXtad",
  render_errors: [view: AgileparkingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Agileparking.PubSub,
  live_view: [signing_salt: "PvqrcwC+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :agileparking, Agileparking.Guardian,
  issuer: "agileparking",
  secret_key: "gfAoRtl2hcydTiH9+NBjt7kLMYxMxsobDSrPAWsb179VpayD08/3glBv4CebDsgW"
