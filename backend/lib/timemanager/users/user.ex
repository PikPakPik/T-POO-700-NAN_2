defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    belongs_to :role, TimeManager.Roles.Role

    many_to_many :teams,
                 TimeManager.Teams.Team,
                 join_through: TimeManager.Teams.TeamEmployees,
                 join_keys: [employee_id: :id, team_id: :id]

    many_to_many :managed_teams,
                 TimeManager.Teams.Team,
                 join_through: TimeManager.Teams.TeamManagers,
                 join_keys: [manager_id: :id, team_id: :id]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:username, :email, :role_id])
    |> default_role()
    |> Ecto.Changeset.validate_required([:username, :email, :role_id])
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> unique_constraint([:email])
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
end
