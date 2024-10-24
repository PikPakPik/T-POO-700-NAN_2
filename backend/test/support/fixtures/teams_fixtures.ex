defmodule TimeManager.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{name: "default name"})
      |> TimeManager.Teams.create_team()

    # Preload the clocks association
    team = TimeManager.Repo.preload(team, :clocks)
    team
  end

  def team2_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{name: "team 2"})
      |> TimeManager.Teams.create_team()

    # Preload the clocks association
    team = TimeManager.Repo.preload(team, :clocks)
    team
  end
end
