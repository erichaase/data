defmodule Data.Fantasy.GameStat do
  use Ecto.Schema
  import Ecto.Changeset


  schema "game_stats" do
    field :ast, :integer
    field :blk, :integer
    field :espn_game_id, :integer
    field :espn_player_id, :integer
    field :fga, :integer
    field :fgm, :integer
    field :first_name, :string
    field :fta, :integer
    field :ftm, :integer
    field :last_name, :string
    field :min, :integer
    field :pts, :integer
    field :rating, :integer
    field :reb, :integer
    field :stl, :integer
    field :to, :integer
    field :tpa, :integer
    field :tpm, :integer

    timestamps()
  end

  @doc false
  def changeset(game_stat, attrs) do
    game_stat
    |> cast(attrs, [:espn_game_id, :espn_player_id, :first_name, :last_name, :min, :fgm, :fga, :ftm, :fta, :tpm, :tpa, :pts, :reb, :ast, :blk, :stl, :to, :rating])
    |> validate_required([:espn_game_id, :espn_player_id, :first_name, :last_name, :min, :fgm, :fga, :ftm, :fta, :tpm, :tpa, :pts, :reb, :ast, :blk, :stl, :to, :rating])
  end
end
