defmodule LoopsWithFriends.PresenceTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.Presence

  describe "`extract_loops/1` when given an empty map" do
    test "returns an empty list" do
      assert Presence.extract_loops(%{}) == []
    end
  end

  describe "`extract_loops/1` when given a populated presence map" do
    test "returns the contained loops" do
      presences = %{
        "user-1" => %{metas: [%{loop_name: "loop_1"}]},
        "user-2" => %{metas: [%{loop_name: "loop_2"}]}
      }

      assert Presence.extract_loops(presences) == ["loop_1", "loop_2"]
    end
  end
end
