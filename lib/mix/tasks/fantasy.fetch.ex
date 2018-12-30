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
    |> inspect
    |> Mix.shell.info
  end
end
