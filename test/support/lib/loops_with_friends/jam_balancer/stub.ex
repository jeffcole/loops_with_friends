defmodule LoopsWithFriends.JamBalancer.Stub do
  @moduledoc """
  Provides a stubbed balancer API for use in testing.
  """

  @behaviour LoopsWithFriends.JamBalancer

  @name __MODULE__

  def start_link(_opts \\ []) do
    {:ok, self()}
  end

  def add_user(_agent \\ @name, jam_id, user)
  def add_user(_agent, "full-jam",  _user), do: :error
  def add_user(_agent, _jam_id, _user), do: :ok

  def current_jam(_agent \\ @name) do
    "jam-1"
  end

  def remove_user(_agent \\ @name, _jam_id, _user_id) do
    %{}
  end

  def stats(_agent \\ @name) do
    %{
      jam_count: 2,
      user_count: 3,
      jams: %{
        "jam-1" => %{user_count: 1},
        "jam-2" => %{user_count: 2}
      }
    }
  end
end
