defmodule TimeManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Teams.{Team, TeamEmployees, TeamManagers, TeamClock}

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
    |> Repo.preload([:clocks])
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Repo.get!(Team, id)
    |> Repo.preload([:clocks])
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def assign_employee_to_team(team_id, employee_id) do
    %TeamEmployees{}
    |> TeamEmployees.changeset(%{team_id: team_id, employee_id: employee_id})
    |> Repo.insert()
  end

  def assign_manager_to_team(team_id, manager_id) do
    %TeamManagers{}
    |> TeamManagers.changeset(%{team_id: team_id, manager_id: manager_id})
    |> Repo.insert()
  end

  def remove_employee_from_team(team_id, employee_id) do
    relation =
      Repo.one(
        from(te in TeamEmployees,
          where: te.team_id == ^team_id and te.employee_id == ^employee_id
        )
      )

    Repo.delete(relation)
  end

  def remove_manager_from_team(team_id, manager_id) do
    relation =
      Repo.one(
        from(tm in TeamManagers, where: tm.team_id == ^team_id and tm.manager_id == ^manager_id)
      )

    Repo.delete(relation)
  end

  # def show_team_clocks(team_id) do
  #   Repo.all(from(c in TeamClock, where: c.team_id == ^team_id))
  # end

  def show_team_clocks(team_id) do
    Repo.all(
      from(c in TeamClock,
        where: c.team_id == ^team_id
      )
    )
    # Précharge les associations
    |> Repo.preload([:team, :clock])
  end

  def create_team_clock(team_id, clock_id) do
    %TeamClock{}
    |> TeamClock.changeset(%{team_id: team_id, clocks_id: clock_id})
    |> Repo.insert()
  end

  def remove_team_clocks(team_id) do
    Repo.delete_all(from(c in TeamClock, where: c.team_id == ^team_id))
  end

  def get_employee_teams!(user_id) do
    Repo.all(from(te in TeamEmployees, where: te.employee_id == ^user_id))
  end

  def get_managing_teams!(user_id) do
    Repo.all(from(tm in TeamManagers, where: tm.manager_id == ^user_id))
  end
end
