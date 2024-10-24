defmodule TimeManager.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field(:name, :string)
    field(:permissions, :map)

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
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name, :permissions])
    |> unique_constraint(:name)
    |> validate_at_least_one_permission()
    |> TimeManager.Roles.Permissions.validate_permissions(:permissions)
  end

  defp validate_at_least_one_permission(changeset) do
    validate_change(changeset, :permissions, fn field, permissions ->
      if map_size(permissions) == 0 do
        [{field, "must have at least one permission"}]
      else
        []
      end
    end)
  end
end
