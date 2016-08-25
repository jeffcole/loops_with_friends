defmodule LoopsWithFriends.LoopCycler do
  @moduledoc """
  Cycles loops.
  """

  @name __MODULE__

  @loops [
    "80s_Back_Beat",
    "Amsterdam_Layers",
    "Synthetic_String_Bass",
    "Degenerating_Pitch_Vox",
    "Kyoto_Night_Guitar",
    "Conga_Groove",
    "African_Rain_Caxixi",
  ]

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)

    Agent.start_link(fn -> @loops end, opts)
  end

  def next_loop(agent_name \\ @name) do
    Agent.get_and_update agent_name, fn [head | tail] ->
      {head, tail ++ [head]}
    end
  end
end
