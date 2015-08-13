# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :storm, Storm.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "eNQk0Vm4AcF2IIW7AL5DVdmlyANo7/xYBVpvc5QcJA+bWxtprAklOYVaVOIaKC0W",
  render_errors: [default_format: "json"],
  pubsub: [name: Storm.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken,
  config_module: Storm.Config.Joken

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :quantum, cron: [
    # Every minute
    "* * * * *": fn -> Storm.Spawner.run end
]