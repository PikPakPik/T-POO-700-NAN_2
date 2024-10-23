defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    belongs_to(:role, TimeManager.Roles.Role)

    many_to_many(
      :teams,
      TimeManager.Teams.Team,
      join_through: TimeManager.Teams.TeamEmployees,
      join_keys: [employee_id: :id, team_id: :id]
    )

    many_to_many(
      :managed_teams,
      TimeManager.Teams.Team,
      join_through: TimeManager.Teams.TeamManagers,
      join_keys: [manager_id: :id, team_id: :id]
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:username, :email, :role_id, :password])
    |> default_role()
    |> Ecto.Changeset.validate_required([:username, :email, :role_id, :password])
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> unique_constraint([:email])
    |> put_password_hash()
  end

  defp default_role(%Ecto.Changeset{} = changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{role_id: _}} ->
        changeset

      %Ecto.Changeset{data: %TimeManager.Users.User{role_id: nil}} ->
        role_id = TimeManager.Roles.get_role_by_name("Employee").id
        Ecto.Changeset.put_change(changeset, :role_id, role_id)

      _ ->
        changeset
    end
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  defimpl Jason.Encoder, for: TimeManager.Users.User do
    def encode(
          %TimeManager.Users.User{id: id, username: username, email: email, role: role},
          opts
        ) do
      Jason.Encode.map(
        %{
          id: id,
          username: username,
          email: email,
          role: role
        },
        opts
      )
    end
  end
end
