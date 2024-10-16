defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    many_to_many :employees,
                 TimeManager.Users.User,
                 join_through: TimeManager.Teams.TeamEmployees,
                 join_keys: [team_id: :id, employee_id: :id]

    many_to_many :managers,
                 TimeManager.Users.User,
                 join_through: TimeManager.Teams.TeamManagers,
                 join_keys: [team_id: :id, manager_id: :id]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
