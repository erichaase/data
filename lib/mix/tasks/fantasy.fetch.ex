defmodule Mix.Tasks.Fantasy.Fetch do
  use Mix.Task

  @shortdoc "Fetches fantasy statistics"

  @moduledoc """
    Fetches fantasy statistics
  """

  def run(args) do
    Mix.Task.run("app.start") # start app so that we can access database
    process_games(List.first(args))
  end

  defp process_games(date) do
    DataWeb.EspnApiClient.scoreboard_game_ids(date)
    |> Enum.each(&process_game/1)
  end

  defp process_game(gid) do
    Mix.shell.info("Fetching game #{gid}")
    DataWeb.EspnGamecastClient.game_stats(gid)
    |> Enum.each(&(process_game_stat(&1, gid)))
  end

  defp process_game_stat(stat, gid) do
    DoesNotExist.for_sure()
    stat
    |> build_game_stat(gid)
    |> inject_rating
    |> upsert_game_stat
  end

  defp build_game_stat(s, gid) do
    [fgm, fga] = String.split(s.fg, "/")
    [ftm, fta] = String.split(s.ft, "/")
    [tpm, tpa] = String.split(s.threept, "/")

# Jan 04 21:57:32 floating-tundra-26312 app/scheduler.2460:  Fetching game 401071247 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:  ** (MatchError) no match of right hand side value: ["-"] 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (data) lib/mix/tasks/fantasy.fetch.ex:34: Mix.Tasks.Fantasy.Fetch.build_game_stat/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (data) lib/mix/tasks/fantasy.fetch.ex:28: Mix.Tasks.Fantasy.Fetch.process_game_stat/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (elixir) lib/enum.ex:765: Enum."-each/2-lists^foreach/1-0-"/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (elixir) lib/enum.ex:765: Enum.each/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (elixir) lib/enum.ex:765: Enum."-each/2-lists^foreach/1-0-"/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (elixir) lib/enum.ex:765: Enum.each/2 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (mix) lib/mix/task.ex:316: Mix.Task.run_task/3 
# Jan 04 21:57:33 floating-tundra-26312 app/scheduler.2460:      (mix) lib/mix/cli.ex:79: Mix.CLI.run_task/2 

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

  def upsert_game_stat(gs) do
    case Data.Fantasy.upsert_game_stat(gs) do
      {:ok, _}            -> nil
      # TODO: rollbar log errors
      {:error, changeset} -> Mix.shell.error("Error upserting: #{inspect(changeset)}")
    end
  end
end
