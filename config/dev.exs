use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :loops_with_friends, LoopsWithFriends.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/webpack/bin/webpack.js", "--watch", "--color",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :loops_with_friends, LoopsWithFriends.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :loops_with_friends, LoopsWithFriends.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "loops_with_friends_dev",
  hostname: "localhost",
  pool_size: 10

config :quantum, cron: [
  "* * * * *": {LoopsWithFriends.Stats, :log}
]
