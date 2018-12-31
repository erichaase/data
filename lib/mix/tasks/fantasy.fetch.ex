defmodule Mix.Tasks.Fantasy.Fetch do
  use Mix.Task

  @shortdoc "Fetches fantasy statistics"

  @moduledoc """
    Fetches fantasy statistics
  """

  def run(_args) do
    # start app so that we can access database
    Mix.Task.run("app.start")

    DataWeb.EspnApiClient.scoreboard_game_ids
    |> Enum.each(&process_game/1)
  end

  defp process_game(gid) do
    Mix.shell.info("Processing game #{gid}...")
    DataWeb.EspnGamecastClient.game_stats(gid)
    # |> inspect
    |> length
    |> Integer.to_string
    |> Mix.shell.info
  end
end
