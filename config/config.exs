# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cookbook,
  ecto_repos: [Cookbook.Repo]

# Configures the endpoint
config :cookbook, Cookbook.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kQOR4HispQgt2SASF23BhPfq4Ggj3scH9VPVXm8uesf8U4J69oI5A5Zig67LGxeE",
  render_errors: [view: Cookbook.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookbook.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
