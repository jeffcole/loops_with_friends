defmodule LoopsWithFriends.StatsCollection do
  @moduledoc """
  Defines the `StatsCollection` type.
  """

  alias LoopsWithFriends.StatsCollection

  defstruct jam_count: 0, user_count: 0, jams: %{}

  @type t ::
    %StatsCollection{
      jam_count: integer,
      user_count: integer,
      jams: %{optional(binary) => %{user_count: integer}}
    }
end
