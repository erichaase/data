defmodule Data.Fantasy.Tasks.GameStat do
  require Logger

  def process(stat, gid) do
    Logger.info "GameStat.process: stat: #{stat.firstName} #{stat.lastName}"
    stat_to_game_stat(stat, gid)
    |> inject_rating
    |> upsert_game_stat
  end

  defp stat_to_game_stat(s, gid) do
    [fgm, fga] = parse_made_attempt_string(s.fg)
    [ftm, fta] = parse_made_attempt_string(s.ft)
    [tpm, tpa] = parse_made_attempt_string(s.threept)

    %{
      espn_game_id: gid,
      espn_player_id: s.id,
      first_name: s.firstName,
      last_name: s.lastName,
      min: str_to_int(s.minutes),
      fgm: str_to_int(fgm),
      fga: str_to_int(fga),
      ftm: str_to_int(ftm),
      fta: str_to_int(fta),
      tpm: str_to_int(tpm),
      tpa: str_to_int(tpa),
      pts: str_to_int(s.points),
      reb: str_to_int(s.rebounds),
      ast: str_to_int(s.assists),
      blk: str_to_int(s.blocks),
      stl: str_to_int(s.steals),
      to:  str_to_int(s.turnovers),
    }
  end

  defp str_to_int(str) do
    case Integer.parse(str) do
      {int, _} -> int
      _        -> 0
    end
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

  defp upsert_game_stat(gs), do: {:ok, _} = Data.Fantasy.upsert_game_stat(gs)
end
