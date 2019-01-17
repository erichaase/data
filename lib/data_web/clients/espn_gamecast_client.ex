defmodule DataWeb.EspnGamecastClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://scores.espn.go.com"
  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.JSON, decode: &decode_json/1

  def game_stats(gid) do
    get_game_stats(gid)
    |> extract_stats
    |> combine_into_list
    |> reject_totals
  end

  defp get_game_stats(gid) do
    # the query string params need to be ordered this way
    get(Enum.join([
      "/nba/gamecast12/master?",
      "xhr=1&",
      "gameId=#{Integer.to_string(gid)}&",
      "lang=en&",
      "init=true&",
      "setType=true&",
      "confId=null",
    ]))
  end
  defp extract_stats({:ok, %{status: 200, body: body}}), do: body.gamecast.stats.player
  defp combine_into_list(%{away: away, home: home}), do: home ++ away
  defp reject_totals(stats) when is_list(stats), do: Enum.reject(stats, &(&1[:firstName] == "TOTALS"))

  # see the following games which include chars that cause problems: 401071214, 401071228
  defp decode_json(json) do
    json
    |> String.codepoints  |> Enum.filter(&String.printable?/1)   |> Enum.join
    |> String.to_charlist |> Enum.filter(&(31 < &1 && &1 < 127)) |> List.to_string
    |> Jason.decode(keys: :atoms)
  end
end
