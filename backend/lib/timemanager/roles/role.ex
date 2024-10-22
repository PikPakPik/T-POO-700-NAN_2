defmodule TimeManager.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field(:name, :string)

    has_many(:users, TimeManager.Users.User)

    timestamps(type: :utc_datetime)
  end

  defimpl Jason.Encoder, for: TimeManager.Roles.Role do
    def encode(%TimeManager.Roles.Role{id: id, name: name}, opts) do
      Jason.Encode.map(%{id: id, name: name}, opts)
    end
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
