defmodule Retro.Repo.Migrations.CreateMembersTable do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :email, :string
      add :room_id, :integer

      timestamps()
    end

    create index(:members, [:room_id])
    create unique_index(:members, [:email, :room_id])
  end
end
