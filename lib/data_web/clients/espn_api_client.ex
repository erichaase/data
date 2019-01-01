defmodule DataWeb.EspnApiClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://site.api.espn.com"
  # TODO: add decode_json to remove unicode chars?
  plug Tesla.Middleware.JSON, engine_opts: [keys: :atoms]

  def scoreboard_game_ids do
    get_scoreboard()
    |> extract_events
    |> reject_inactive
    |> map_game_id
  end

  defp get_scoreboard do
    path = "/apis/site/v2/sports/basketball/nba/scoreboard"
    qs_params = %{
      "lang" => "en",
      "region" => "us",
      "calendartype" => "blacklist",
      "limit" => "100",
      # "dates" => "20181231",
    }
    get("#{path}?#{URI.encode_query(qs_params)}")
  end
  defp extract_events({:ok, %{status: 200, body: body}}), do: body.events
  defp reject_inactive(events) when is_list(events), do: Enum.reject(events, &(&1[:status][:type][:state] == "pre"))
  defp map_game_id(events), do: Enum.map(events, &(String.to_integer(&1[:id])))
end
