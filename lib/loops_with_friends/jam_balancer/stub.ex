defmodule LoopsWithFriends.JamBalancer.Stub do
  @moduledoc """
  Provides a stubbed balancer API for use in testing.
  """

  @behaviour LoopsWithFriends.JamBalancer

  @name __MODULE__

  def start_link(_opts \\ []) do
    {:ok, self()}
  end

  def refresh(_agent \\ @name, _jam_id, _presence_map) do
    %{}
  end

  def current_jam(_agent \\ @name) do
    "jams:1"
  end

  def remove_user(_agent \\ @name, _jam_id, _user_id) do
    %{}
  end
end
