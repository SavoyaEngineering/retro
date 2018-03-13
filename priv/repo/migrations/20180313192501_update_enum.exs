defmodule Retro.Repo.Migrations.UpdateEnum do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up do
    Ecto.Migration.execute "ALTER TYPE type ADD VALUE 'action_msg'"
  end

  def down do
  end
end
