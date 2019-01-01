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
