use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loops_with_friends, LoopsWithFriends.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :loops_with_friends, LoopsWithFriends.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "loops_with_friends_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :loops_with_friends, :jam_balancer, LoopsWithFriends.JamBalancer.Stub

config :loops_with_friends, :jam_collection,
  LoopsWithFriends.JamCollection.Stub
