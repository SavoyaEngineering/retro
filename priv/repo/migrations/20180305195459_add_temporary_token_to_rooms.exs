defmodule Retro.Repo.Migrations.AddTemporaryTokenToRooms do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      add :temporary_token, :string
    end
  end
end
