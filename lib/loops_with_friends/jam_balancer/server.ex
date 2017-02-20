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

  def add_user(agent \\ @name, jam_id, user_id, opts \\ []) do
    Agent.get_and_update agent, fn jams ->
      case @jam_collection.add_user(jams, jam_id, user_id, opts) do
        {:ok, new_jams} ->
          {:ok, new_jams}
        {:error} ->
          {:error, jams}
      end
    end
  end

  def current_jam(agent \\ @name) do
    @jam_collection.most_populated_jam_with_capacity_or_new(jams(agent))
  end

  def remove_user(agent \\ @name, jam_id, user_id, opts \\ []) do
    Agent.update agent, fn jams ->
      @jam_collection.remove_user(jams, jam_id, user_id, opts)
    end
  end

  def stats(agent \\ @name) do
    @jam_collection.stats(jams(agent))
  end

  defp jams(agent) do
    Agent.get(agent, &(&1))
  end
end
