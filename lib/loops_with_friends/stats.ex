defmodule LoopsWithFriends.Stats do
  @moduledoc """
  Persists jam and user counts at the current time.
  """

  alias LoopsWithFriends.{AppStat, JamStat, Repo}

  require Logger

  @jam_balancer Application.get_env(:loops_with_friends, :jam_balancer)

  def collect do
    stats = @jam_balancer.stats

    {:ok, app_stat} = Repo.insert(
      %AppStat{jam_count: stats.jam_count, user_count: stats.user_count}
    )

    Repo.insert_all(JamStat, jam_stats(stats.jams, app_stat.id))
  end

  def log do
    stats = @jam_balancer.stats
    app_stats = Map.take(stats, [:jam_count, :user_count])
    jam_stats = Map.take(stats, [:jams])

    Logger.info("AppStats: #{inspect app_stats}")
    Logger.info("JamStats: #{inspect jam_stats}")

    Apex.ap(app_stats)
    Apex.ap(jam_stats)
  end

  defp jam_stats(jams, app_stat_id) do
    Enum.map jams, fn {jam_id, jam_stats} ->
      Map.merge(jam_stats, %{app_stat_id: app_stat_id, jam_id: jam_id})
    end
  end
end
