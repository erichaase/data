defmodule Data.Fantasy.Tasks.Scoreboard do
  def process(date \\ nil) do
    IO.puts "Scoreboard.process: processing"
    Data.Fantasy.Clients.EspnApi.scoreboard_game_ids(date)
    |> Enum.each(&start_box_score_task/1)
  end

  defp start_box_score_task(gid) do
    IO.puts gid
    # Task.start(DataWeb.EspnApiClient, :scoreboard_game_ids, [])
  end
end
