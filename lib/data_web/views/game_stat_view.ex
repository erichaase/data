defmodule DataWeb.GameStatView do
  use DataWeb, :view

  def table_row_class(game_stat) do
    player_ids = System.get_env("PLAYER_IDS")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    if Enum.member?(player_ids, game_stat.espn_player_id) do
      "mine"
    else
      if game_stat.rating >= 0 do
        "positive"
      else
        "negative"
      end
    end
  end
end
