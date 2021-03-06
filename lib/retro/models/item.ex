defmodule Retro.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Retro.{Repo, Item}

  schema "items" do
    field :text, :string
    field :type, :string
    field :room_id, :integer
    field :archived, :boolean
    field :thumbs_up_count, :integer

    timestamps()
  end

  def changeset(%Item{} = item, attrs \\ %{}) do
    item
    |> cast(attrs, [:text, :type, :room_id, :archived, :thumbs_up_count])
    |> validate_required([:room_id], message: "Room ID required")
    |> validate_required([:text], message: "Text required")
    |> validate_required([:type], message: "Type required")
  end

  def create(%{} = change) do
    changeset(%Item{}, change)
    |> Repo.insert
  end

  def as_json(%Item{} = item) do
    %{
      id: item.id,
      text: item.text,
      room_id: item.room_id,
      archived: item.archived,
      type: item.type,
      thumbs_up_count: item.thumbs_up_count
    }
  end

  def archive(%Item{} = item) do
    changeset(item, %{archived: true})
      |> Repo.update
  end
end
