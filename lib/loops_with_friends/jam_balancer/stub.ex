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

  def jam_full?(_agent \\ @name, jam_id)
  def jam_full?(_agent, "jam-1"), do: false
  def jam_full?(_agent, "full-jam"), do: true

  def remove_user(_agent \\ @name, _jam_id, _user_id) do
    %{}
  end
end
