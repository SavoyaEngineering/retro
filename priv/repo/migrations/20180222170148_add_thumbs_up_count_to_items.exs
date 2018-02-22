defmodule Retro.Repo.Migrations.AddThumbsUpCountToItems do
  use Ecto.Migration

  def change do
    alter table("items") do
      add :thumbs_up_count, :integer, default: 0
    end
  end
end
