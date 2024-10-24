defmodule TimeManagerWeb.TeamsControllerTest do
  use TimeManagerWeb.ConnCase
  import TimeManager.UsersFixtures
  import TimeManager.TeamsFixtures

  alias TimeManager.Auth
  alias TimeManager.Repo
  alias TimeManager.WorkingTimes.WorkingTime

  setup %{conn: conn} do
    user = employee_fixture() |> Repo.preload([:role, :teams, :managed_teams])
    manager = manager_fixture() |> Repo.preload([:role, :teams, :managed_teams])
    admin = admin_fixture() |> Repo.preload([:role])

    team = team_fixture()
    team_2 = team2_fixture()

    {jwt, xsrf} = Auth.generate_jwt(user)
    {jwt_manager, xsrf_manager} = Auth.generate_jwt(manager)
    {jwt_admin, xsrf_admin} = Auth.generate_jwt(admin)

    conn_user =
      conn
      |> put_req_cookie("jwt", jwt)
      |> put_req_header("c-xsrf-token", xsrf)
      |> put_req_header("accept", "application/json")

    conn_user = assign(conn_user, :current_user, user)

    conn_manager =
      conn
      |> put_req_cookie("jwt", jwt_manager)
      |> put_req_header("c-xsrf-token", xsrf_manager)
      |> put_req_header("accept", "application/json")

    conn_manager = assign(conn_manager, :current_user, manager)

    conn_admin =
      conn
      |> put_req_cookie("jwt", jwt_admin)
      |> put_req_header("c-xsrf-token", xsrf_admin)
      |> put_req_header("accept", "application/json")

    conn_admin = assign(conn_admin, :current_user, admin)

    %{
      conn_user: conn_user,
      conn_manager: conn_manager,
      conn_admin: conn_admin,
      user: user,
      manager: manager,
      admin: admin,
      team: team,
      team_2: team_2
    }
  end

  ################################################################
  # The roles hierarchy is the following:
  # - Admin > Manager > Employee
  # All roles inherit the permissions of the role below them in the hierarchy.
  # So we don't need to test all routes for each role, only the ones that
  # are not inherited from the role below.
  ################################################################

  describe "index action" do
    test "Simple user can see teams", %{
      conn_user: conn_user,
      user: user
    } do
      conn = get(conn_user, "/api/teams")

      assert json_response(conn, 200)["data"] |> length() == 2
    end
  end

  describe "show action" do
    test "Simple user can see team", %{
      conn_user: conn_user,
      user: user,
      team: team
    } do
      conn = get(conn_user, "/api/teams/#{team.id}")

      assert json_response(conn, 200)["data"]["id"] == team.id
    end
  end

  describe "Create / Update / Delete team / Add / Remove employee / Add / Remove manager" do
    test "Simple user can't create / update / delete team / add_employee / remove_employee / add_manager / remove_manager",
         %{
           conn_user: conn_user,
           user: user,
           team: team
         } do
      conn = post(conn_user, "/api/teams")
      assert response(conn, 403)

      conn = put(conn_user, "/api/teams/#{team.id}")
      assert response(conn, 403)

      conn = delete(conn_user, "/api/teams/#{team.id}")
      assert response(conn, 403)

      conn = put(conn_user, "/api/teams/#{team.id}/add_employee/#{user.id}")
      assert response(conn, 403)

      conn = put(conn_user, "/api/teams/#{team.id}/remove_employee/#{user.id}")
      assert response(conn, 403)

      conn = put(conn_user, "/api/teams/#{team.id}/add_manager/#{user.id}")
      assert response(conn, 403)

      conn = put(conn_user, "/api/teams/#{team.id}/remove_manager/#{user.id}")
      assert response(conn, 403)
    end
  end

  describe "When having permissions to do the following actions" do
    test "Create team", %{
      conn_manager: conn_manager,
      manager: manager
    } do
      valid_team_attrs = %{team: %{name: "new team"}}

      conn = post(conn_manager, "/api/teams", valid_team_attrs)
      assert response(conn, 201)
      new_team = json_response(conn, 201)["data"]
      assert new_team["name"] == "new team"
    end

    test "Update team", %{
      conn_manager: conn_manager,
      manager: manager,
      team: team
    } do
      change_team_attrs = %{team: %{name: "changed team"}}
      conn = put(conn_manager, "/api/teams/#{team.id}", change_team_attrs)
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["name"] == "changed team"
    end

    test "Delete team", %{
      conn_manager: conn_manager,
      manager: manager,
      team: team
    } do
      conn = delete(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 204)
    end

    test "Add employee to team", %{
      conn_manager: conn_manager,
      manager: manager,
      user: user,
      team: team
    } do
      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["employees"] |> length() == 0

      conn = put(conn_manager, "/api/teams/#{team.id}/add_employee/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["employees"] |> length() == 1
    end

    test "Remove employee from team", %{
      conn_manager: conn_manager,
      manager: manager,
      user: user,
      team: team
    } do
      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["employees"] |> length() == 0

      conn = put(conn_manager, "/api/teams/#{team.id}/add_employee/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["employees"] |> length() == 1

      conn = put(conn_manager, "/api/teams/#{team.id}/remove_employee/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["employees"] |> length() == 0
    end

    test "Add manager to team", %{
      conn_manager: conn_manager,
      manager: manager,
      user: user,
      team: team
    } do
      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["managers"] |> length() == 0

      conn = put(conn_manager, "/api/teams/#{team.id}/add_manager/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["managers"] |> length() == 1
    end

    test "Remove manager from team", %{
      conn_manager: conn_manager,
      manager: manager,
      user: user,
      team: team
    } do
      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["managers"] |> length() == 0

      conn = put(conn_manager, "/api/teams/#{team.id}/add_manager/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["managers"] |> length() == 1

      conn = put(conn_manager, "/api/teams/#{team.id}/remove_manager/#{user.id}")
      assert response(conn, 200)

      conn = get(conn_manager, "/api/teams/#{team.id}")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"]["managers"] |> length() == 0
    end

    test "Get team working times", %{
      conn_manager: conn_manager,
      manager: manager,
      team: team
    } do
      conn = get(conn_manager, "/api/teams/#{team.id}/workingtimes")
      assert response(conn, 200)
      assert json_response(conn, 200)["data"] |> length() == 0
    end
  end
end
