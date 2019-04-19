defmodule Retro.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Retro.{Repo, Room}

  schema "rooms" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :temporary_token, :string
    field :retro_day, :string
    field :retro_time, :string
    field :slack_hook_address, :string

    timestamps()
  end

  def changeset(%Room{} = room, attrs \\ %{}) do
    room
    |> cast(attrs, [:name, :password, :temporary_token, :retro_day, :retro_time, :slack_hook_address])
    |> validate_required([:name], message: "Name required")
    |> validate_required([:password], message: "Password required")
    |> unique_constraint(:name, message: "Name has already been taken")
    |> hash_password()
  end

  def create(%{} = change) do
    changeset(%Room{}, change)
    |> Repo.insert
  end

  def as_json(%Room{} = room) do
    %{
      id: room.id,
      name: room.name
    }
  end

  defp hash_password(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             password: password
           }
         } = changeset
       ) do
    change(changeset, password_hash: Comeonin.Argon2.hashpwsalt(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
