defmodule LoopsWithFriends do
  @moduledoc """
  A collaborative music-making web app.
  """

  use Application

  alias LoopsWithFriends.Endpoint

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(LoopsWithFriends.Endpoint, []),
      # Start the Ecto repository
      supervisor(LoopsWithFriends.Repo, []),
      supervisor(LoopsWithFriends.Presence, []),
      worker(LoopsWithFriends.LoopCycler, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LoopsWithFriends.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
