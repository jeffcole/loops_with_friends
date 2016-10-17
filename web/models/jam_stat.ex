defmodule LoopsWithFriends.JamStat do
  use LoopsWithFriends.Web, :model

  schema "jam_stats" do
    belongs_to :app_stat, AppStat

    field :jam_id, :string
    field :user_count, :integer
  end
end
