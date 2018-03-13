defmodule Retro.Member do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Retro.{Repo, Member, Room}

  schema "members" do
    field :email, :string
    field :room_id, :integer

    timestamps()
  end

  def changeset(%Member{} = member, attrs \\ %{}) do
    member
    |> cast(attrs, [:email, :room_id])
    |> validate_required([:room_id], message: "Room ID required")
    |> validate_required([:email], message: "Email required")
    |> unique_constraint(:email, name: :members_email_room_id_index, message: "This member exists already")
  end

  def add_members(%Room{} = room, emails) do
    existing_members = from member in "members", where: member.room_id == ^room.id, select: member.email

    (emails -- Repo.all(existing_members))
    |> Enum.map(&Repo.insert(%Member{room_id: room.id, email: &1}))
  end

  def as_json(%Member{} = member) do
    %{
      id: member.id,
      email: member.email
    }
  end
end
