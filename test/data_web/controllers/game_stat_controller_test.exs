defmodule DataWeb.GameStatControllerTest do
  use DataWeb.ConnCase

  alias Data.Fantasy

  @create_attrs %{ast: 42, blk: 42, espn_game_id: 42, espn_player_id: 42, fga: 42, fgm: 42, first_name: "some first_name", fta: 42, ftm: 42, last_name: "some last_name", min: 42, pts: 42, rating: 42, reb: 42, stl: 42, to: 42, tpa: 42, tpm: 42}
  @update_attrs %{ast: 43, blk: 43, espn_game_id: 43, espn_player_id: 43, fga: 43, fgm: 43, first_name: "some updated first_name", fta: 43, ftm: 43, last_name: "some updated last_name", min: 43, pts: 43, rating: 43, reb: 43, stl: 43, to: 43, tpa: 43, tpm: 43}
  @invalid_attrs %{ast: nil, blk: nil, espn_game_id: nil, espn_player_id: nil, fga: nil, fgm: nil, first_name: nil, fta: nil, ftm: nil, last_name: nil, min: nil, pts: nil, rating: nil, reb: nil, stl: nil, to: nil, tpa: nil, tpm: nil}

  def fixture(:game_stat) do
    {:ok, game_stat} = Fantasy.create_game_stat(@create_attrs)
    game_stat
  end

  describe "index" do
    test "lists all game_stats", %{conn: conn} do
      conn = get(conn, Routes.game_stat_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Game stats"
    end
  end

  describe "new game_stat" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.game_stat_path(conn, :new))
      assert html_response(conn, 200) =~ "New Game stat"
    end
  end

  describe "create game_stat" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_stat_path(conn, :create), game_stat: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_stat_path(conn, :show, id)

      conn = get(conn, Routes.game_stat_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Game stat"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_stat_path(conn, :create), game_stat: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Game stat"
    end
  end

  describe "edit game_stat" do
    setup [:create_game_stat]

    test "renders form for editing chosen game_stat", %{conn: conn, game_stat: game_stat} do
      conn = get(conn, Routes.game_stat_path(conn, :edit, game_stat))
      assert html_response(conn, 200) =~ "Edit Game stat"
    end
  end

  describe "update game_stat" do
    setup [:create_game_stat]

    test "redirects when data is valid", %{conn: conn, game_stat: game_stat} do
      conn = put(conn, Routes.game_stat_path(conn, :update, game_stat), game_stat: @update_attrs)
      assert redirected_to(conn) == Routes.game_stat_path(conn, :show, game_stat)

      conn = get(conn, Routes.game_stat_path(conn, :show, game_stat))
      assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "renders errors when data is invalid", %{conn: conn, game_stat: game_stat} do
      conn = put(conn, Routes.game_stat_path(conn, :update, game_stat), game_stat: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game stat"
    end
  end

  describe "delete game_stat" do
    setup [:create_game_stat]

    test "deletes chosen game_stat", %{conn: conn, game_stat: game_stat} do
      conn = delete(conn, Routes.game_stat_path(conn, :delete, game_stat))
      assert redirected_to(conn) == Routes.game_stat_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.game_stat_path(conn, :show, game_stat))
      end
    end
  end

  defp create_game_stat(_) do
    game_stat = fixture(:game_stat)
    {:ok, game_stat: game_stat}
  end
end
