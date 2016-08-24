defmodule LoopsWithFriends.LoopCyclerTest do
  use ExUnit.Case

  alias LoopsWithFriends.LoopCycler

  test "cycles the loop list" do
    LoopCycler.start_link

    assert LoopCycler.next_loop == "80s_Back_Beat"
    assert LoopCycler.next_loop == "Amsterdam_Layers"
    assert LoopCycler.next_loop == "Synthetic_String_Bass"
    assert LoopCycler.next_loop == "Degenerating_Pitch_Vox"
    assert LoopCycler.next_loop == "Kyoto_Night_Guitar"
    assert LoopCycler.next_loop == "Conga_Groove"
    assert LoopCycler.next_loop == "African_Rain_Caxixi"
    assert LoopCycler.next_loop == "80s_Back_Beat"
  end
end
