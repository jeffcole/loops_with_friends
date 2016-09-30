defmodule LoopsWithFriends.JamBalancer.ServerTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.JamBalancer.Server

  setup do
    Server.start_link(name: __MODULE__)
    current_jam = fn -> Server.current_jam(__MODULE__) end

    {:ok, current_jam: current_jam}
  end

  describe "`current_jam/0` when there are no users" do
    test "returns a UUID", %{current_jam: current_jam} do
      assert UUID.info!(current_jam.())
    end
  end

  describe "`current_jam/0` when the last jam has fewer than seven users" do
    test "returns the last jam", %{current_jam: current_jam} do
      initial_jam = current_jam.()
      refresh_with_one_user(initial_jam)

      assert current_jam.() == initial_jam
    end
  end

  describe "`current_jam/0` when the last jam has seven users" do
    test "returns a different jam", %{current_jam: current_jam} do
      initial_jam = current_jam.()
      refresh_with_seven_users(initial_jam)

      assert current_jam.() != initial_jam
    end
  end

  describe "`current_jam/0` after a user is removed from a full jam" do
    test "returns that jam", %{current_jam: current_jam} do
      initial_jam = current_jam.()
      refresh_with_seven_users(initial_jam)
      remove_user(initial_jam)

      assert current_jam.() == initial_jam
    end
  end

  describe "`current_jam/0` when a previous jam has a user removed" do
    test "returns the previous jam", %{current_jam: current_jam} do
      initial_jam = current_jam.()
      refresh_with_seven_users(initial_jam)

      second_jam = current_jam.()
      refresh_with_one_user(second_jam)
      remove_user(initial_jam)

      assert current_jam.() == initial_jam
    end
  end

  defp refresh_with_one_user(jam) do
    Server.refresh(__MODULE__, jam, one_user())
  end

  defp refresh_with_seven_users(jam) do
    Server.refresh(__MODULE__, jam, seven_users())
  end

  defp remove_user(jam) do
    Server.remove_user(__MODULE__, jam, "user-3")
  end

  defp one_user do
    %{"user-1" => %{}}
  end

  defp seven_users do
    %{"user-1" => %{},
      "user-2" => %{},
      "user-3" => %{},
      "user-4" => %{},
      "user-5" => %{},
      "user-6" => %{},
      "user-7" => %{}}
  end
end
