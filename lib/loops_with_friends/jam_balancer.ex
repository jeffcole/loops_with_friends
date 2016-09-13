defmodule LoopsWithFriends.JamBalancer do
  @moduledoc """
  Ensures that there are never more than `@max_users` users in a given jam.
  """

  @name __MODULE__
  @max_users 7

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)

    Agent.start_link(fn -> %{} end, opts)
  end

  def refresh(agent \\ @name, jam_id, presence_map) do
    Agent.update agent, fn jams ->
      put_in jams[jam_id], Map.keys(presence_map)
    end
  end

  def remove(agent \\ @name, jam_id, user_id) do
    Agent.update agent, fn jams ->
      users =
        jams[jam_id]
        |> List.delete(user_id)

      update(jams, jam_id, users)
    end
  end

  def current_jam(agent \\ @name) do
    do_current_jam(jams(agent))
  end

  defp jams(agent) do
    Agent.get(agent, &(&1))
  end

  defp do_current_jam(jams) when jams == %{}, do: uuid()
  defp do_current_jam(jams) do
    jam_with_most_users_under_max(jams) || uuid()
  end

  defp jam_with_most_users_under_max(jams) do
    jams
    |> Enum.filter(&less_than_max_users/1)
    |> Enum.into(%{})
    |> Enum.sort_by(&users/1, &more_first/2)
    |> List.first
    |> jam_or_nil_tuple
    |> elem(0)
  end

  defp jam_or_nil_tuple(jam_tuple) do
    if jam_tuple do
      jam_tuple
    else
      {nil}
    end
  end

  defp less_than_max_users({_jam_id, users}) do
    Enum.count(users) < @max_users
  end

  defp users({_jam_id, users}) do
    users
  end

  defp more_first(users_1, users_2) do
    Enum.count(users_1) >= Enum.count(users_2)
  end

  defp uuid do
    UUID.uuid4()
  end

  defp update(jams, jam_id, []) do
    Map.delete(jams, jam_id)
  end

  defp update(jams, jam_id, users) do
    put_in jams[jam_id], users
  end
end
