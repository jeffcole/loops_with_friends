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
    "jam-1"
  end

  def jam_capacity?(_agent \\ @name, jam_id)
  def jam_capacity?(_agent, "jam-1"), do: true
  def jam_capacity?(_agent, "full-jam"), do: false

  def remove_user(_agent \\ @name, _jam_id, _user_id) do
    %{}
  end
end
