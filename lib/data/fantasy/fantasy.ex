defmodule Data.Fantasy do
  @moduledoc """
  The Fantasy context.
  """

  import Ecto.Query, warn: false
  alias Data.Repo

  alias Data.Fantasy.GameStat

  @doc """
  Returns the list of game_stats.

  ## Examples

      iex> list_game_stats()
      [%GameStat{}, ...]

  """
  def list_game_stats do
    Repo.all(GameStat)
  end

  @doc """
  Returns the list of game_stats for the past day

  ## Examples

      iex> list_game_stats_last_day()
      [%GameStat{}, ...]

  """
  def list_game_stats_last_day do
    one_day_ago = NaiveDateTime.utc_now(Calendar.ISO) |> NaiveDateTime.add(-86_400)
    query = from gs in GameStat,
      where: gs.inserted_at > ^one_day_ago,
      order_by: [desc: :rating]
    Repo.all(query)
  end

  @doc """
  Gets a single game_stat.

  Raises `Ecto.NoResultsError` if the Game stat does not exist.

  ## Examples

      iex> get_game_stat!(123)
      %GameStat{}

      iex> get_game_stat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_stat!(id), do: Repo.get!(GameStat, id)

  @doc """
  Gets a single game_stat using attrs.
  """
  def get_by_game_stat(attrs), do: Repo.get_by(GameStat, attrs)

  @doc """
  Creates a game_stat.

  ## Examples

      iex> create_game_stat(%{field: value})
      {:ok, %GameStat{}}

      iex> create_game_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_stat(attrs \\ %{}) do
    %GameStat{}
    |> GameStat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_stat.

  ## Examples

      iex> update_game_stat(game_stat, %{field: new_value})
      {:ok, %GameStat{}}

      iex> update_game_stat(game_stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_stat(%GameStat{} = game_stat, attrs) do
    game_stat
    |> GameStat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Upserts a single game_stat.
  """
  def upsert_game_stat(attrs) do
    query = %{espn_game_id: attrs.espn_game_id, espn_player_id: attrs.espn_player_id}
    case get_by_game_stat(query) do
      nil -> %GameStat{}
      gs  -> gs
    end
    |> GameStat.changeset(attrs)
    |> Repo.insert_or_update
  end

  @doc """
  Deletes a GameStat.

  ## Examples

      iex> delete_game_stat(game_stat)
      {:ok, %GameStat{}}

      iex> delete_game_stat(game_stat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_stat(%GameStat{} = game_stat) do
    Repo.delete(game_stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_stat changes.

  ## Examples

      iex> change_game_stat(game_stat)
      %Ecto.Changeset{source: %GameStat{}}

  """
  def change_game_stat(%GameStat{} = game_stat) do
    GameStat.changeset(game_stat, %{})
  end
end
