defmodule LoopsWithFriends.AppStat do
  @moduledoc """
  Application statistics for a given point in time.
  """

  use LoopsWithFriends.Web, :model

  schema "app_stats" do
    timestamps(updated_at: false)

    field :jam_count, :integer
    field :user_count, :integer
  end
end
