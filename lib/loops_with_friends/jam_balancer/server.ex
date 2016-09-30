defmodule LoopsWithFriends.JamBalancer.Server do
  @moduledoc """
  Provides a stateful API for a `JamCollection`.
  """

  @behaviour LoopsWithFriends.JamBalancer

  @jam_collection Application.get_env(:loops_with_friends, :jam_collection)

  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)

    Agent.start_link(fn -> @jam_collection.new(opts) end, opts)
  end

  def refresh(agent \\ @name, jam_id, presence_map, opts \\ []) do
    Agent.update agent, fn jams ->
      @jam_collection.refresh(jams, jam_id, Map.keys(presence_map), opts)
    end
  end

  def current_jam(agent \\ @name) do
    @jam_collection.most_populated_with_capacity(jams(agent))
  end

  def jam_full?(agent \\ @name, jam_id) do
    @jam_collection.jam_full?(jams(agent), jam_id)
  end

  def remove_user(agent \\ @name, jam_id, user_id, opts \\ []) do
    Agent.update agent, fn jams ->
      @jam_collection.remove_user(jams, jam_id, user_id, opts)
    end
  end

  defp jams(agent) do
    Agent.get(agent, &(&1))
  end
end
