defmodule LoopsWithFriends.LoopCyclerTest do
  use ExUnit.Case, async: true

  alias LoopsWithFriends.LoopCycler

  describe "`next_loop/1` given an empty list" do
    test "returns the first loop" do
      assert LoopCycler.next_loop([]) == "80s_Back_Beat"
    end
  end

  describe "`next_loop/1` given a list of loops" do
    test "returns a loop not present in the given list" do
      loops = ["80s_Back_Beat", "Amsterdam_Layers", "Degenerating_Pitch_Vox"]

      assert LoopCycler.next_loop(loops) == "Synthetic_String_Bass"
    end
  end

  describe "`next_loop/1` given a list containing all loops" do
    test "returns `nil`" do
      assert LoopCycler.next_loop(LoopCycler.all_loops()) == nil
    end
  end
end
