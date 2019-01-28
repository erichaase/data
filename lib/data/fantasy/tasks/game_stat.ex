defmodule Data.Fantasy.Tasks.GameStat do
  require Logger

  def store(gs) do
    Logger.info "GameStat.process: player: #{gs.first_name} #{gs.last_name} #{gs.rating}"
    {:ok, _} = Data.Fantasy.upsert_game_stat(gs)
  end
end
