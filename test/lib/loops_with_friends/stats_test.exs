defmodule LoopsWithFriends.StatsTest do
  use LoopsWithFriends.DatabaseCase, async: true

  alias LoopsWithFriends.{AppStat, JamStat, Stats}

  setup do
    Stats.collect

    :ok
  end

  describe "`collect`" do
    test "persists the current jam and user counts across the app" do
      assert match? %AppStat{jam_count: 2, user_count: 3}, Repo.one(AppStat)
    end

    test "persists the distribution of users across jams" do
      app_stat_id = Repo.one(AppStat).id
      jam_stats = Repo.all(JamStat)

      assert Enum.any?(jam_stats, &match?(
        %JamStat{app_stat_id: ^app_stat_id, jam_id: "jam-1", user_count: 1}, &1
      ))
      assert Enum.any?(jam_stats, &match?(
        %JamStat{app_stat_id: ^app_stat_id, jam_id: "jam-2", user_count: 2}, &1
      ))
    end
  end
end
