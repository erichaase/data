defmodule Data.Fantasy.Tasks.BoxScore do
  require Logger

  def process(gid) do
    Logger.info "BoxScore.process: game: #{gid}"
    Data.Fantasy.Clients.EspnGamecast.stats(gid)
    |> Enum.each(&(start_game_stat_task(&1, gid)))
  end

  defp start_game_stat_task(stat, gid) do
    Task.start(Data.Fantasy.Tasks.GameStat, :process, [stat, gid])
  end
end
