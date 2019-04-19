defmodule Retro.Repo.Migrations.AddSlackHookAddressToRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :slack_hook_address, :string
    end
  end
end
