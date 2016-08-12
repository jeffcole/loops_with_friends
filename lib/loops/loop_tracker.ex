defmodule Loops.LoopTracker do
  @loops [
    "80s_Back_Beat",
    "Amsterdam_Layers",
    "Synthetic_String_Bass",
    "Degenerating_Pitch_Vox",
    "Kyoto_Night_Guitar",
    "Conga_Groove",
    "African_Rain_Caxixi",
  ]

  def start_link do
    Agent.start_link(fn -> @loops end, name: __MODULE__)
  end

  def next_loop do
    Agent.get_and_update __MODULE__, fn [head | tail] ->
      {head, tail ++ [head]}
    end
  end
end
