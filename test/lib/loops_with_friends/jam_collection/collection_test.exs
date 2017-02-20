defmodule LoopsWithFriends.JamCollection.CollectionTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.{JamCollection.Collection, StatsCollection}

  describe "`new/0`" do
    test "returns an empty map" do
      assert Collection.new() == %{}
    end
  end

  describe "`add_user/3`" do
    test "places the user in the jam with the given id" do
      assert {:ok, collection} = Collection.add_user(
        Collection.new(), "jam-1", "user-1"
      )

      assert collection == %{"jam-1" => ["user-1"]}
    end

    test "preserves existing users" do
      collection = %{"jam-1" => ["user-1"]}

      assert {:ok, updated_collection} = Collection.add_user(
        collection, "jam-1", "user-2"
      )

      assert updated_collection == %{"jam-1" => ["user-1", "user-2"]}
    end

    test "returns an error when the user would overflow the jam" do
      collection = %{"jam-1" => list_of_seven_users()}

      assert {:error} = Collection.add_user(collection, "jam-1", "user-8")
    end
  end

  describe "`most_populated_jam_with_capacity_or_new/1`" do
    test "given an empty collection returns a UUID" do
      assert UUID.info!(Collection.most_populated_jam_with_capacity_or_new(%{}))
    end

    test "given a full jam returns a new jam" do
      jams = %{"jam-1" => list_of_seven_users()}
      result = Collection.most_populated_jam_with_capacity_or_new(jams)

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
      result = Collection.most_populated_jam_with_capacity_or_new(jams)

      assert result == "jam-2"
    end
  end

  describe "`remove_user/3`" do
    test "removes a user from a jam" do
      jams = %{"jam-1" => ["user-1", "user-2"], "jam-2" => ["user-1"]}

      result = Collection.remove_user(jams, "jam-1", "user-1")

      assert result == %{"jam-1" => ["user-2"], "jam-2" => ["user-1"]}
    end

    test "removes a jam when its last user is removed" do
      jams = %{"jam-1" => ["user-1"], "jam-2" => ["user-1"]}

      result = Collection.remove_user(jams, "jam-1", "user-1")

      assert result == %{"jam-2" => ["user-1"]}
    end
  end

  describe "`stats/0`" do
    test "given an empty collection returns zero counts" do
      assert Collection.stats(%{}) ==
        %StatsCollection{jam_count: 0, user_count: 0, jams: %{}}
    end

    test "given a populated collection returns non-zero counts" do
      result = Collection.stats(
        %{"jam-1" => list_of_six_users(), "jam-2" => list_of_seven_users()}
      )

      assert result ==
        %StatsCollection{
          jam_count: 2,
          user_count: 13,
          jams: %{
            "jam-1" => %{user_count: 6},
            "jam-2" => %{user_count: 7}
          }
        }
      end
  end

  defp list_of_seven_users do
    ["user-1", "user-2", "user-3", "user-4", "user-5", "user-6", "user-7"]
  end

  defp list_of_six_users do
    ["user-1", "user-2", "user-3", "user-4", "user-5", "user-6"]
  end
end
