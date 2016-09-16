defmodule LoopsWithFriends.JamCollectionTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.JamCollection

  describe "`new/0`" do
    test "returns an empty map" do
      assert JamCollection.new() == %{}
    end
  end

  describe "`refresh/3`" do
    test "places the given users in the jam with the given id" do
      collection = JamCollection.refresh(
        JamCollection.new(),
        "jam-1",
        ["user-1"]
      )

      assert collection == %{"jam-1" => ["user-1"]}
    end

    test "replaces the contents of the given jam" do
      collection = %{"jam-1" => ["user-1"]}
      refreshed_collection = JamCollection.refresh(
        collection,
        "jam-1",
        ["user-2"]
      )

      assert refreshed_collection == %{"jam-1" => ["user-2"]}
    end
  end

  describe "`most_populated_with_capacity/1`" do
    test "given an empty collection returns a UUID" do
      assert UUID.info!(JamCollection.most_populated_with_capacity(%{}))
    end

    test "given a full jam returns a new jam" do
      jams = %{"jam-1" => list_of_seven_users()}
      result = JamCollection.most_populated_with_capacity(jams)

      assert result != "jam-1"
    end

    test "given jams of varying population returns the one with the most users
          under the max" do
      jams = %{
        "jam-1" => list_of_seven_users(),
        "jam-2" => list_of_six_users(),
        "jam-3" => list_of_seven_users(),
        "jam-4" => list_of_seven_users()
      }
      result = JamCollection.most_populated_with_capacity(jams)

      assert result == "jam-2"
    end
  end

  describe "`remove_user/3`" do
    test "removes a user from a jam" do
      jams = %{"jam-1" => ["user-1", "user-2"], "jam-2" => ["user-1"]}

      result = JamCollection.remove_user(jams, "jam-1", "user-1")

      assert result == %{"jam-1" => ["user-2"], "jam-2" => ["user-1"]}
    end

    test "removes a jam when its last user is removed" do
      jams = %{"jam-1" => ["user-1"], "jam-2" => ["user-1"]}

      result = JamCollection.remove_user(jams, "jam-1", "user-1")

      assert result == %{"jam-2" => ["user-1"]}
    end
  end

  defp list_of_seven_users do
    ["user-1", "user-2", "user-3", "user-4", "user-5", "user-6", "user-7"]
  end

  defp list_of_six_users do
    ["user-1", "user-2", "user-3", "user-4", "user-5", "user-6"]
  end
end
