defmodule Retro.Room do
  @moduledoc """
  Provides interface for retro rooms.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Retro.{Repo, Room}

  schema "rooms" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Changeset for room.
  name and password are required.
  """
  def changeset(%Room{} = room, attrs \\ %{}) do
    room
    |> cast(attrs, [:name, :password])
    |> validate_required([:name], message: "Name required")
    |> validate_required([:password], message: "Password required")
    |> hash_password()
  end

  @doc """
  Creates a new room
  """
  def create(%{} = change) do
    changeset(%Room{}, change)
    |> Repo.insert
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
