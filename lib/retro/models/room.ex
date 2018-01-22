defmodule Retro.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Retro.{Repo, Room}

  schema "rooms" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create(%Room{} = room) do
    Repo.insert(room)
  end
end
