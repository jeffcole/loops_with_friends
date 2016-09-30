defmodule LoopsWithFriends.JamBalancer do
  @moduledoc """
  Behavior for maintaining and balancing among a collection of jams.
  """

  @callback start_link(opts :: Keyword.t) :: Agent.on_start

  @callback refresh(agent :: module, jam_id :: String.t, presence_map :: Map.t)
            :: Map.t

  @callback current_jam(agent :: module) :: String.t

  @callback remove_user(
              agent :: module,
              jam_id :: String.t, 
              user_id :: String.t
            )
            :: Map.t
end
