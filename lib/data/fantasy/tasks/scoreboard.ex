defmodule Data.Fantasy.Tasks.Scoreboard do
  def process(date \\ nil) do
    IO.puts "Scoreboard.process: date: #{if date, do: date, else: "now"}"
    Data.Fantasy.Clients.EspnApi.scoreboard_game_ids(date)
    |> Enum.each(&start_box_score_task/1)
  end

  defp start_box_score_task(gid) do
    Task.start(Data.Fantasy.Tasks.BoxScore, :process, [gid])
  end
end
