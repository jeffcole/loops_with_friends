# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :loops_with_friends, LoopsWithFriends.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "xA37helMDnP8D7u7fmHE+bYT+UxpXmor3z808NXr09eZKRuUKPnwghJLNz9cZQO7",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: LoopsWithFriends.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :loops_with_friends, ecto_repos: [LoopsWithFriends.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :loops_with_friends, :jam_balancer, LoopsWithFriends.JamBalancer.Server

config :loops_with_friends, :jam_collection,
  LoopsWithFriends.JamCollection.Collection

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
