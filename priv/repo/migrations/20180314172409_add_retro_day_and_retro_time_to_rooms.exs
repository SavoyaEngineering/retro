defmodule Retro.Repo.Migrations.AddRetroDayAndRetroTimeToRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :retro_day, :string
      add :retro_time, :string
    end
  end
end
