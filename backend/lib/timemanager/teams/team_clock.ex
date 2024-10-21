defmodule TimeManager.Teams.TeamClock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_clocks" do
    field :team_id, :id
    field :clocks_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_id, :clocks_id])
    |> validate_required([:team_id, :clocks_id])
  end
end
