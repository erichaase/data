defmodule Mix.Tasks.Fantasy.Fetch do
  use Mix.Task

  @shortdoc "Fetches fantasy statistics"

  @moduledoc """
    Fetches fantasy statistics
  """

  def run(_args) do
    # start app so that we can access database
    Mix.Task.run("app.start")

    DataWeb.EspnApiClient.scoreboard_game_ids
    |> Enum.each(&process_game/1)
  end

  defp process_game(gid) do
    Mix.shell.info("processing game: #{gid}")

    DataWeb.EspnGamecastClient.game_stats(gid)
    |> Enum.each(&process_game_stat/1)
  end

  defp process_game_stat(stat) do
    stat
    |> build_game_stat
    |> inspect
    |> Mix.shell.info
    # |> upsert_game_stat
  end

  defp build_game_stat(s) do
    [fgm, fga] = String.split(s.fg, "/")
    [ftm, fta] = String.split(s.ft, "/")
    [tpm, tpa] = String.split(s.threept, "/")

    # TODO: use ecto model
    %{
      espn_id: s.id,
      first_name: s.firstName,
      last_name: s.lastName,
      min: s.minutes,
      fgm: fgm,
      fga: fga,
      ftm: ftm,
      fta: fta,
      tpm: tpm,
      tpa: tpa,
      pts: String.to_integer(s.points),
      reb: String.to_integer(s.rebounds),
      ast: String.to_integer(s.assists),
      blk: String.to_integer(s.blocks),
      stl: String.to_integer(s.steals),
      to: String.to_integer(s.turnovers)
    }
  end
end
