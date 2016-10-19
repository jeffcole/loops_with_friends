defmodule LoopsWithFriends.JamStat do
  @moduledoc """
  Jam statistics for a given point in time.
  """

  use LoopsWithFriends.Web, :model

  schema "jam_stats" do
    belongs_to :app_stat, AppStat

    field :jam_id, :string
    field :user_count, :integer
  end
end
