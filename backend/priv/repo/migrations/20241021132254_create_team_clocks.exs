defmodule TimeManager.Repo.Migrations.CreateTeamClocks do
  use Ecto.Migration

  def change do
    create table(:team_clocks) do
      add :team_id, references(:teams, type: :integer, on_delete: :delete_all), primary_key: true
      add :clocks_id, references(:clocks, type: :integer, on_delete: :delete_all), primary_key: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_clocks, [:team_id, :clocks_id])
  end
end
