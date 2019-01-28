defmodule Data.Cron do
  use GenServer

  # Client Functions
  def start_link(_), do: GenServer.start_link(__MODULE__, :no_args)

  # Server Functions
  def init(:no_args) do
    schedule_next_process_scoreboard()
    {:ok, nil}
  end

  def handle_info(:process_scoreboard, _) do
    Task.start(Data.Fantasy.Tasks.Scoreboard, :process, [])
    schedule_next_process_scoreboard()
    {:noreply, nil}
  end

  defp schedule_next_process_scoreboard do
    Process.send_after(self(), :process_scoreboard, 5 * 60 * 1000)
  end
end
