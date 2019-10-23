defmodule DataWeb.GameStatController do
  use DataWeb, :controller

  alias Data.Fantasy
  alias Data.Fantasy.GameStat

  def index(conn, _params) do
    {:ok, start_dt} = Fantasy.get_game_stat_mri().inserted_at
    |> NaiveDateTime.add(-21_600)
    |> NaiveDateTime.to_date()
    |> NaiveDateTime.new(~T[00:00:00])
    game_stats = Fantasy.list_game_stats_since(start_dt)
    render(conn, "index.html", game_stats: game_stats)
  end

  def new(conn, _params) do
    changeset = Fantasy.change_game_stat(%GameStat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game_stat" => game_stat_params}) do
    case Fantasy.create_game_stat(game_stat_params) do
      {:ok, game_stat} ->
        conn
        |> put_flash(:info, "Game stat created successfully.")
        |> redirect(to: Routes.game_stat_path(conn, :show, game_stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game_stat = Fantasy.get_game_stat!(id)
    render(conn, "show.html", game_stat: game_stat)
  end

  def edit(conn, %{"id" => id}) do
    game_stat = Fantasy.get_game_stat!(id)
    changeset = Fantasy.change_game_stat(game_stat)
    render(conn, "edit.html", game_stat: game_stat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game_stat" => game_stat_params}) do
    game_stat = Fantasy.get_game_stat!(id)

    case Fantasy.update_game_stat(game_stat, game_stat_params) do
      {:ok, game_stat} ->
        conn
        |> put_flash(:info, "Game stat updated successfully.")
        |> redirect(to: Routes.game_stat_path(conn, :show, game_stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game_stat: game_stat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_stat = Fantasy.get_game_stat!(id)
    {:ok, _game_stat} = Fantasy.delete_game_stat(game_stat)

    conn
    |> put_flash(:info, "Game stat deleted successfully.")
    |> redirect(to: Routes.game_stat_path(conn, :index))
  end
end
