defmodule LoopsWithFriends.JamCollection do
  @moduledoc """
  Behavior defining the explicit contract for real and stub jam collections.
  """

  alias LoopsWithFriends.StatsCollection

  @callback new :: Map.t

  @callback add_user(
    jams :: Map.t,
    jam_id :: String.t,
    new_user :: Map.t
  ) ::
    Agent.on_start

  @callback most_populated_jam_with_capacity_or_new(jams :: Map.t) :: String.t

  @callback remove_user(
    jams :: Map.t,
    jam_id :: String.t,
    user_id :: String.t
  ) ::
    Map.t

  @callback stats(jams :: Map.t) :: StatsCollection.t
end
