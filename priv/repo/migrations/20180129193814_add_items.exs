defmodule Retro.Repo.Migrations.AddItems do
  use Ecto.Migration

  def up do
    StatusEnum.create_type
    create table(:items) do
      add :text, :string
      add :type, :type
      add :room_id, :integer

      timestamps()
    end

    create index("items", [:room_id])
  end

  def down do
    drop table(:items)
    StatusEnum.drop_type
  end
end
