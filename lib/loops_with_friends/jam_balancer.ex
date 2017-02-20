defmodule LoopsWithFriends.JamBalancer do
  @moduledoc """
  Behavior for maintaining and balancing among a collection of jams.
  """

  alias LoopsWithFriends.StatsCollection

  @callback start_link(opts :: Keyword.t) :: Agent.on_start

  @callback add_user(
    agent :: module,
    jam_id :: String.t,
    user_id :: String.t
  ) ::
    :ok | :error

  @callback current_jam(agent :: module) :: String.t

  @callback remove_user(
    agent :: module,
    jam_id :: String.t,
    user_id :: String.t
  ) ::
    Map.t

  @callback stats :: StatsCollection.t
end
