defmodule LoopsWithFriends.LoopCycler do
  @moduledoc """
  Cycles loops while filtering out those already present.
  """

  defmodule NoRemainingLoopsError do
    defexception message: "There are no loops remaining to return."
  end

  @loops [
    "80s_Back_Beat",
    "Amsterdam_Layers",
    "Synthetic_String_Bass",
    "Degenerating_Pitch_Vox",
    "Kyoto_Night_Guitar",
    "Conga_Groove",
    "African_Rain_Caxixi",
  ]

  def next_loop([]), do: hd(all_loops())
  def next_loop(present_loops) do
    next_loop_or_nil(present_loops) || raise(NoRemainingLoopsError)
  end

  def all_loops do
    @loops
  end

  defp next_loop_or_nil(present_loops) do
    all_loops()
    |> Enum.reject(fn loop -> loop in present_loops end)
    |> List.first
  end
end
