defmodule Data.Fantasy.Tasks.GameStat do
  def store(gs) do
    IO.puts "GameStat.process: player: #{gs.first_name} #{gs.last_name} #{gs.rating}"
    {:ok, _} = Data.Fantasy.upsert_game_stat(gs)
  end
end
