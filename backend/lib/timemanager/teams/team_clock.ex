defmodule TimeManager.Teams.TeamClock do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :inserted_at, :updated_at]}
  schema "team_clocks" do
    belongs_to :team, TimeManager.Teams.Team
    belongs_to :clock, TimeManager.Clocks.Clock, foreign_key: :clocks_id  # Spécifie le nom de la colonne

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_clock, attrs) do
    team_clock
    |> cast(attrs, [:team_id, :clocks_id])
    |> validate_required([:team_id, :clocks_id])
  end
end
