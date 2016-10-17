defmodule LoopsWithFriends.Repo.Migrations.CreateStats do
  use Ecto.Migration

  def change do
    create table(:app_stats) do
      timestamps(updated_at: false)

      add :jam_count, :integer
      add :user_count, :integer
    end

    create table(:jam_stats) do
      add :app_stat_id, references(:app_stats)

      add :jam_id, :string
      add :user_count, :integer
    end
  end
end
