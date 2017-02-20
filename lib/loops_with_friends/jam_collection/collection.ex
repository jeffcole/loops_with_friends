defmodule LoopsWithFriends.JamCollection.Collection do
  @moduledoc """
  Represents a collection of jams, indexed by UUID and containing a list of
  users.

  Ensures that there are never more than `@max_users` users in a given jam.
  """

  @behaviour LoopsWithFriends.JamCollection

  alias LoopsWithFriends.StatsCollection

  @max_users 7

  def new(_opts \\ []), do: %{}

  def add_user(jams, jam_id, new_user, _opts \\ []) do
    jam_users = jams[jam_id] || []

    collection = put_in(jams[jam_id], Enum.concat(jam_users, [new_user]))

    if length(collection[jam_id]) <= @max_users do
      {:ok, collection}
    else
      {:error}
    end
  end

  def most_populated_jam_with_capacity_or_new(jams) when jams == %{}, do: uuid()
  def most_populated_jam_with_capacity_or_new(jams) do
    jam_with_most_users_under_max(jams) || uuid()
  end

  def remove_user(jams, jam_id, user_id, _opts \\ []) do
    users =
      jams[jam_id]
      |> List.delete(user_id)

    update(jams, jam_id, users)
  end

  def stats(jams) do
    jams
    |> Enum.reduce(%StatsCollection{}, &accumulate_stats/2)
  end

  defp jam_with_most_users_under_max(jams) do
    jams
    |> Enum.filter(&less_than_max_users/1)
    |> Enum.sort_by(&users/1, &more_first/2)
    |> List.first
    |> jam_id_or_nil
  end

  defp jam_id_or_nil(nil), do: nil
  defp jam_id_or_nil({jam_id, _users}) do
    jam_id
  end

  defp less_than_max_users({_jam_id, users}) do
    length(users) < @max_users
  end

  defp users({_jam_id, users}) do
    users
  end

  defp more_first(users_1, users_2) do
    length(users_1) >= length(users_2)
  end

  defp update(jams, jam_id, []) do
    Map.delete(jams, jam_id)
  end

  defp update(jams, jam_id, users) do
    put_in jams[jam_id], users
  end

  defp accumulate_stats({jam_id, users}, stats) do
    %StatsCollection{
      jam_count: stats.jam_count + 1,
      user_count: stats.user_count + length(users),
      jams: Map.merge(stats.jams, %{jam_id => %{user_count: length(users)}})
    }
  end

  defp uuid do
    UUID.uuid4()
  end
end
