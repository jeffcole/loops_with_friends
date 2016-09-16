defmodule LoopsWithFriends.JamBalancer do
  @moduledoc """
  Provides a stateful API for a `JamCollection`.
  """

  alias LoopsWithFriends.JamCollection

  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)

    Agent.start_link(fn -> JamCollection.new() end, opts)
  end

  def refresh(agent \\ @name, jam_id, presence_map) do
    Agent.update agent, fn jams ->
      JamCollection.refresh(jams, jam_id, Map.keys(presence_map))
    end
  end

  def current_jam(agent \\ @name) do
    JamCollection.most_populated_with_capacity(jams(agent))
  end

  def remove_user(agent \\ @name, jam_id, user_id) do
    Agent.update agent, fn jams ->
      JamCollection.remove_user(jams, jam_id, user_id)
    end
  end

  defp jams(agent) do
    Agent.get(agent, &(&1))
  end
end
