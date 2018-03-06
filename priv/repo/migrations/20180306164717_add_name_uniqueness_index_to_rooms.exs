defmodule Retro.Repo.Migrations.AddNameUniquenessIndexToRooms do
  use Ecto.Migration

  def change do
    create unique_index(:rooms, [:name])
  end
end
