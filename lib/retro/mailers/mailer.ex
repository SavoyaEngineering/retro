defmodule Retro.Mailer do

  def send_join_room_email(emails) do
    Enum.map(String.split(emails, ","), &send_email(&1))
  end

  defp send_email(email_address) do
    SendGrid.Email.build()
    |> SendGrid.Email.add_to(String.trim(email_address))
    |> SendGrid.Email.put_from("development@savoya.com")
    |> SendGrid.Email.put_subject("Join the Retro")
    |> SendGrid.Email.put_text("https://remarkable-lightyellow-seaslug.gigalixirapp.com/join_room?t=temp_token")
    |> SendGrid.Mailer.send()
  end

end