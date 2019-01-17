defmodule Mix.Tasks.Fantasy.Fetch do
  use Mix.Task

  @shortdoc "Fetches fantasy statistics"

  @moduledoc """
    Fetches fantasy statistics
  """

  def run(args) do
    Mix.Task.run("app.start") # start app so that we can access database
    process_games(List.first(args))

    # TODO: get Rollbar working
    # try do
    # rescue
    #   e -> Rollbax.report(:error, e, System.stacktrace())
    # end
  end

  defp process_games(date) do
    DataWeb.EspnApiClient.scoreboard_game_ids(date)
    |> Enum.each(&process_game/1)
  end

  defp process_game(gid) do
    Mix.shell.info("Fetching game #{gid}")
    try do
      DataWeb.EspnGamecastClient.game_stats(gid)
      |> Enum.each(&(process_game_stat(&1, gid)))
    rescue
      e -> IO.inspect(e)
    end
  end

  defp process_game_stat(stat, gid) do
    stat
    |> build_game_stat(gid)
    |> inject_rating
    |> upsert_game_stat
  end

  defp build_game_stat(s, gid) do
    [fgm, fga] = parse_made_attempt_string(s.fg)
    [ftm, fta] = parse_made_attempt_string(s.ft)
    [tpm, tpa] = parse_made_attempt_string(s.threept)

    %{
      espn_game_id: gid,
      espn_player_id: s.id,
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

  defp parse_made_attempt_string(s) do
    case String.split(s, "/") do
      [m, a] -> [m, a]
      _      -> ["0", "0"]
    end
  end

  defp inject_rating(gs) do
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
    Map.put(gs, :rating, Kernel.trunc(rating))
  end

  defp upsert_game_stat(gs) do
    case Data.Fantasy.upsert_game_stat(gs) do
      {:ok, _}            -> nil
      # TODO: rollbar log errors
      {:error, changeset} -> Mix.shell.error("Error upserting: #{inspect(changeset)}")
    end
  end
end
