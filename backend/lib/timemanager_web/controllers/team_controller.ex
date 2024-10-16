defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManagerWeb.SwaggerDef

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    SwaggerDef.team_definitions()
  end

  swagger_path(:index) do
    summary("List teams")
    description("List all teams in the database.")

    response(200, "OK", Schema.ref(:TeamsResponse))
  end

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  swagger_path(:create) do
    summary("Create team")
    description("Create a team.")

    parameter(:team, :body, Schema.ref(:TeamRequest), "Team object", required: true)

    response(201, "OK", Schema.ref(:TeamResponse))
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  swagger_path(:show) do
    summary("Show team")
    description("Show a team by ID.")
    parameter(:id, :path, :integer, "Team ID", required: true, example: 1)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  swagger_path(:update) do
    summary("Update team")
    description("Update a team entry.\nScopes: team.update")

    parameter(:id, :path, :integer, "Team ID", required: true, example: 1)
    parameter(:team, :body, Schema.ref(:TeamRequest), "Team object", required: true)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  swagger_path(:delete) do
    summary("Delete team")
    description("Delete a team by ID.")
    parameter(:id, :path, :integer, "Team ID", required: true, example: 1)

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path(:clock) do
    summary("Clock team users")
    description("Clock all team users.")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 1)

    response(200, "OK", Schema.ref(:TeamClockResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def clock(conn, %{"teamID" => team_id}) do
    team = TimeManager.Repo.preload(Teams.get_team!(team_id), :employees)

    results =
      team.employees
      |> Enum.map(fn employee ->
        case TimeManager.Clocks.clock_in_out_user(employee.id) do
          {:ok, %TimeManager.Clocks.Clock{} = clock} ->
            TimeManagerWeb.ModelToJson.serialize_data(clock)

          _error ->
            # Handle error or return a meaningful message
            %{}
        end
      end)

    conn
    |> json(%{data: results})
  end

  swagger_path(:add_employee) do
    summary("Add employee")
    description("Add a new user as a team employee.")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 1)
    parameter(:employeeID, :path, :integer, "Employee ID (User ID)", required: true, example: 1)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def add_employee(conn, %{"teamID" => team_id, "employeeID" => employee_id}) do
    team = Teams.get_team!(team_id)

    Teams.assign_employee_to_team(team.id, employee_id)
    render(conn, :show, team: team)
  end

  swagger_path(:remove_employee) do
    summary("Remove employee")
    description("Remove a team employee.")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 1)
    parameter(:employeeID, :path, :integer, "Employee ID (User ID)", required: true, example: 1)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def remove_employee(conn, %{"teamID" => team_id, "employeeID" => employee_id}) do
    team = Teams.get_team!(team_id)

    Teams.remove_employee_from_team(team.id, employee_id)
    render(conn, :show, team: team)
  end

  swagger_path(:add_manager) do
    summary("Add manager")
    description("Add a new user as a team manager.")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 1)
    parameter(:managerID, :path, :integer, "Manager ID (User ID)", required: true, example: 1)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def add_manager(conn, %{"teamID" => team_id, "managerID" => manager_id}) do
    team = Teams.get_team!(team_id)
    Teams.assign_manager_to_team(team.id, manager_id)
    render(conn, :show, team: team)
  end

  swagger_path(:remove_manager) do
    summary("Remove manager")
    description("Remove a team manager.")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:managerID, :path, :integer, "Manager ID (User ID)", required: true, example: 123)

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def remove_manager(conn, %{"teamID" => team_id, "managerID" => manager_id}) do
    team = Teams.get_team!(team_id)

    Teams.remove_manager_from_team(team.id, manager_id)
    render(conn, :show, team: team)
  end
end
