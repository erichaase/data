defmodule Data.FantasyTest do
  use Data.DataCase

  alias Data.Fantasy

  describe "game_stats" do
    alias Data.Fantasy.GameStat

    @valid_attrs %{ast: 42, blk: 42, espn_game_id: 42, espn_player_id: 42, fga: 42, fgm: 42, first_name: "some first_name", fta: 42, ftm: 42, last_name: "some last_name", min: 42, pts: 42, rating: 42, reb: 42, stl: 42, to: 42, tpa: 42, tpm: 42}
    @update_attrs %{ast: 43, blk: 43, espn_game_id: 43, espn_player_id: 43, fga: 43, fgm: 43, first_name: "some updated first_name", fta: 43, ftm: 43, last_name: "some updated last_name", min: 43, pts: 43, rating: 43, reb: 43, stl: 43, to: 43, tpa: 43, tpm: 43}
    @invalid_attrs %{ast: nil, blk: nil, espn_game_id: nil, espn_player_id: nil, fga: nil, fgm: nil, first_name: nil, fta: nil, ftm: nil, last_name: nil, min: nil, pts: nil, rating: nil, reb: nil, stl: nil, to: nil, tpa: nil, tpm: nil}

    def game_stat_fixture(attrs \\ %{}) do
      {:ok, game_stat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fantasy.create_game_stat()

      game_stat
    end

    test "list_game_stats/0 returns all game_stats" do
      game_stat = game_stat_fixture()
      assert Fantasy.list_game_stats() == [game_stat]
    end

    test "get_game_stat!/1 returns the game_stat with given id" do
      game_stat = game_stat_fixture()
      assert Fantasy.get_game_stat!(game_stat.id) == game_stat
    end

    test "create_game_stat/1 with valid data creates a game_stat" do
      assert {:ok, %GameStat{} = game_stat} = Fantasy.create_game_stat(@valid_attrs)
      assert game_stat.ast == 42
      assert game_stat.blk == 42
      assert game_stat.espn_game_id == 42
      assert game_stat.espn_player_id == 42
      assert game_stat.fga == 42
      assert game_stat.fgm == 42
      assert game_stat.first_name == "some first_name"
      assert game_stat.fta == 42
      assert game_stat.ftm == 42
      assert game_stat.last_name == "some last_name"
      assert game_stat.min == 42
      assert game_stat.pts == 42
      assert game_stat.rating == 42
      assert game_stat.reb == 42
      assert game_stat.stl == 42
      assert game_stat.to == 42
      assert game_stat.tpa == 42
      assert game_stat.tpm == 42
    end

    test "create_game_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fantasy.create_game_stat(@invalid_attrs)
    end

    test "update_game_stat/2 with valid data updates the game_stat" do
      game_stat = game_stat_fixture()
      assert {:ok, %GameStat{} = game_stat} = Fantasy.update_game_stat(game_stat, @update_attrs)
      assert game_stat.ast == 43
      assert game_stat.blk == 43
      assert game_stat.espn_game_id == 43
      assert game_stat.espn_player_id == 43
      assert game_stat.fga == 43
      assert game_stat.fgm == 43
      assert game_stat.first_name == "some updated first_name"
      assert game_stat.fta == 43
      assert game_stat.ftm == 43
      assert game_stat.last_name == "some updated last_name"
      assert game_stat.min == 43
      assert game_stat.pts == 43
      assert game_stat.rating == 43
      assert game_stat.reb == 43
      assert game_stat.stl == 43
      assert game_stat.to == 43
      assert game_stat.tpa == 43
      assert game_stat.tpm == 43
    end

    test "update_game_stat/2 with invalid data returns error changeset" do
      game_stat = game_stat_fixture()
      assert {:error, %Ecto.Changeset{}} = Fantasy.update_game_stat(game_stat, @invalid_attrs)
      assert game_stat == Fantasy.get_game_stat!(game_stat.id)
    end

    test "delete_game_stat/1 deletes the game_stat" do
      game_stat = game_stat_fixture()
      assert {:ok, %GameStat{}} = Fantasy.delete_game_stat(game_stat)
      assert_raise Ecto.NoResultsError, fn -> Fantasy.get_game_stat!(game_stat.id) end
    end

    test "change_game_stat/1 returns a game_stat changeset" do
      game_stat = game_stat_fixture()
      assert %Ecto.Changeset{} = Fantasy.change_game_stat(game_stat)
    end
  end
end
