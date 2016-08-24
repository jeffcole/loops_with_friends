defmodule LoopsWithFriends.LoopTrackerTest do
  use ExUnit.Case

  import LoopsWithFriends.LoopTracker, only: [start_link: 0, next_loop: 0]

  test "cycles the loop list" do
    start_link

    assert next_loop == "80s_Back_Beat"
    assert next_loop == "Amsterdam_Layers"
    assert next_loop == "Synthetic_String_Bass"
    assert next_loop == "Degenerating_Pitch_Vox"
    assert next_loop == "Kyoto_Night_Guitar"
    assert next_loop == "Conga_Groove"
    assert next_loop == "African_Rain_Caxixi"
    assert next_loop == "80s_Back_Beat"
  end
end
