defmodule Retro.RetroReminder do
  use GenServer
  use Timex
  import Ecto.Query, only: [from: 2]

  alias Retro.{Repo, Room, Member, Mailer, SlackAlerter}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(state) do
    Process.send_after(self(), :remind, 1000)
    {:ok, state}
  end

  def handle_info(:remind, state) do
    now = Timex.now("America/Chicago")

    retro_day = now |> Timex.weekday |> Timex.day_name

    date_time_parts = DateTime.to_string(now) |> String.split(" ")
    time_parts = String.split(Enum.at(date_time_parts, 1), ":")
    retro_time = [Enum.at(time_parts, 0), Enum.at(time_parts, 1)] |> Enum.join("")

    room_query = from room in Room,
                  where: room.retro_day == ^retro_day and room.retro_time == ^retro_time

    Enum.each(Repo.all(room_query), fn(room) ->
      email_query = from member in Member,
                      where: member.room_id == ^room.id,
                      select: member.email
      Mailer.send_join_room_email(Repo.all(email_query), room.temporary_token)

      if room.slack_hook_address do
        SlackAlerter.alert(room.slack_hook_address, room.temporary_token)
      end
    end)

    Process.send_after(self(), :remind, 60 * 1000) # In 1 minute

    {:noreply, state}
  end
end