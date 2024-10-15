defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    belongs_to :role, TimeManager.Roles.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role_id])
    |> validate_required([:username, :email, :role_id])
    |> default_role()
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> unique_constraint([:email])
  end

   defp default_role(%Ecto.Changeset{changes: %{role_id: _}} = changeset) do
    changeset
  end

  defp default_role(%Ecto.Changeset{data: %TimeManager.Users.User{role_id: nil}} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(:role_id, TimeManager.Roles.get_role_by_name("Employee").id)
  end

  defp default_role(changeset) do
    changeset
  end
end
