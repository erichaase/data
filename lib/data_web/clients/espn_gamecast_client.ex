defmodule DataWeb.EspnGamecastClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://www.espn.com"
  # TODO: use atoms as keys: https://hexdocs.pm/jason/Jason.html#decode/2
  plug Tesla.Middleware.JSON, decode: &decode_json/1

  def game_stats(gid) do
    get_game_stats(gid)
    |> extract_stats
    |> transform_to_list
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
  defp extract_stats({:ok, %{status: 200, body: body}}), do: body["gamecast"]["stats"]["player"]
  defp transform_to_list(%{"away" => away, "home" => home}), do: home ++ away
  defp reject_totals(stats), do: Enum.reject(stats, &(&1["firstName"] == "TOTALS"))

  defp decode_json(json) do
    json
    |> String.to_charlist
    |> Enum.filter(&(31 < &1 && &1 < 128))
    |> List.to_string
    |> Jason.decode
  end
end
