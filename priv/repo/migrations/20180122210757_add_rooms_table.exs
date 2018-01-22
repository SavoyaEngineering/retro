defmodule Retro.Repo.Migrations.AddRoomsTable do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string

      timestamps()
    end
  end
end
