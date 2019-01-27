defmodule Data.Cron do
  use GenServer

  # Client Functions

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Server Functions

  def init(_) do
    schedule_next_process_scoreboard
    {:ok, nil}
  end

  def handle_info(:process_scoreboard, _) do
    IO.inspect "Testing: #{DateTime.utc_now}"
    # Task.start(DataWeb.EspnApiClient, :scoreboard_game_ids, [])
    schedule_next_process_scoreboard
    {:noreply, nil}
  end

  defp schedule_next_process_scoreboard do
    Process.send_after(self(), :process_scoreboard, 5 * 60 * 1000)
  end
end
