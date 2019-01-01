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
    |> insert_rating
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
      min: String.to_integer(s.minutes),
      fgm: String.to_integer(fgm),
      fga: String.to_integer(fga),
      ftm: String.to_integer(ftm),
      fta: String.to_integer(fta),
      tpm: String.to_integer(tpm),
      tpa: String.to_integer(tpa),
      pts: String.to_integer(s.points),
      reb: String.to_integer(s.rebounds),
      ast: String.to_integer(s.assists),
      blk: String.to_integer(s.blocks),
      stl: String.to_integer(s.steals),
      to:  String.to_integer(s.turnovers),
    }
  end

  defp insert_rating(gs) do
    fgp = if (gs.fga == 0), do: 0, else: (gs.fgm / gs.fga - 0.464) * (gs.fga / 20.1) * 97.6
    ftp = if (gs.fta == 0), do: 0, else: (gs.ftm / gs.fta - 0.790) * (gs.fta / 11.7) * 78.1
    tpm = (gs.tpm - 0.9 ) * 3.5
    pts = (gs.pts - 15.6) * 0.5
    reb = (gs.reb - 5.6 ) * 0.9
    ast = (gs.ast - 3.7 ) * 1.1
    stl = (gs.stl - 1.1 ) * 6.4
    blk = (gs.blk - 0.6 ) * 4.9
    to  = (gs.to  - 2.0 ) * -3.4
    rating = fgp + ftp + tpm + pts + reb + ast + stl + blk + to
    Map.put(gs, :rating, rating)
  end
end
