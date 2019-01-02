defmodule DataWeb.EspnGamecastClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://www.espn.com"
  plug Tesla.Middleware.JSON, decode: &decode_json/1

  def game_stats(gid) do
    get_game_stats(gid)
    |> extract_stats
    |> combine_into_list
    |> reject_totals
  end

  defp get_game_stats(gid) do
    path = "/nba/gamecast12/master"
    qs_params = %{
      "xhr" => "1",
      "lang" => "en",
      "init" => "true",
      "setType" => "true",
      "confId" => "null",
      "gameId" => Integer.to_string(gid)
    }
    get("#{path}?#{URI.encode_query(qs_params)}")
  end
  defp extract_stats({:ok, %{status: 200, body: body}}), do: body.gamecast.stats.player
  defp combine_into_list(%{away: away, home: home}), do: home ++ away
  defp reject_totals(stats) when is_list(stats), do: Enum.reject(stats, &(&1[:firstName] == "TOTALS"))

  # see the following games which include chars that cause problems: 401071214, 401071228
  defp decode_json(json) do
    json
    |> String.codepoints
    |> Enum.filter(&(String.printable?(&1) && &1 != "\r"))
    |> Enum.join
    |> Jason.decode(keys: :atoms)
  end
end
