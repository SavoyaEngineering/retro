defmodule Retro.Item do
  @moduledoc """
  Provides interface for retro items.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Retro.{Repo, Item}

  schema "items" do
    field :text, :string
    field :type, :string
    field :room_id, :integer
    field :archived, :boolean

    timestamps()
  end

  @doc """
  Changeset for an item.
  room_id, text, and type are required.
  """
  def changeset(%Item{} = item, attrs \\ %{}) do
    item
    |> cast(attrs, [:text, :type, :room_id, :archived])
    |> validate_required([:room_id], message: "Room ID required")
    |> validate_required([:text], message: "Text required")
    |> validate_required([:type], message: "Type required")
  end

  @doc """
  Creates a new item
  """
  def create(%{} = change) do
    changeset(%Item{}, change)
    |> Repo.insert
  end


  @doc """
  Archives a given item
  """
  def archive(%Item{} = item) do
    changeset(item, %{archived: true})
      |> Repo.update
  end
end
