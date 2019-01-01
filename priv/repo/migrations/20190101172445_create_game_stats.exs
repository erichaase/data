defmodule Data.Repo.Migrations.CreateGameStats do
  use Ecto.Migration

  def change do
    create table(:game_stats) do
      add :espn_game_id, :integer
      add :espn_player_id, :integer
      add :first_name, :string
      add :last_name, :string
      add :min, :integer
      add :fgm, :integer
      add :fga, :integer
      add :ftm, :integer
      add :fta, :integer
      add :tpm, :integer
      add :tpa, :integer
      add :pts, :integer
      add :reb, :integer
      add :ast, :integer
      add :blk, :integer
      add :stl, :integer
      add :to, :integer
      add :rating, :integer

      timestamps()
    end

  end
end
