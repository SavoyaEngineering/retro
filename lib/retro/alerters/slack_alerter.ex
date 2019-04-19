defmodule Retro.SlackAlerter do

  def alert(hook_address, token) do
    #TODO add test
    HTTPoison.post(
      hook_address,
      build_body(token)
    )
  end

  defp build_body(token) do
    %{
      "text" => "Join the Retro: https://remarkable-lightyellow-seaslug.gigalixirapp.com/rooms/join_room?t=#{token}"
    } |> Poison.encode!
  end
end