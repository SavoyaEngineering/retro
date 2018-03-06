defmodule Retro.Mailer do

  def send_join_room_email(emails, token) do
    #TODO add test
    Enum.map(String.split(emails, ","), &send_email(&1, token))
  end

  defp send_email(email_address, token) do
    SendGrid.Email.build()
    |> SendGrid.Email.add_to(String.trim(email_address))
    |> SendGrid.Email.put_from("development@savoya.com")
    |> SendGrid.Email.put_subject("Join the Retro")
    |> SendGrid.Email.put_text("https://remarkable-lightyellow-seaslug.gigalixirapp.com/rooms/join_room?t=#{token}")
    |> SendGrid.Mailer.send()
  end

end