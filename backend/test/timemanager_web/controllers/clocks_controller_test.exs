defmodule TimeManagerWeb.ClocksControllerTest do
  use TimeManagerWeb.ConnCase
  import TimeManager.UsersFixtures
  import TimeManager.ClocksFixtures

  alias TimeManager.Auth
  alias TimeManager.Repo
  alias TimeManager.WorkingTimes.WorkingTime

  setup %{conn: conn} do
    user = employee_fixture() |> Repo.preload([:role])
    manager = manager_fixture() |> Repo.preload([:role])

    {jwt, xsrf} = Auth.generate_jwt(user)
    {jwt_manager, xsrf_manager} = Auth.generate_jwt(manager)

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

    %{
      conn_user: conn_user,
      conn_manager: conn_manager,
      user: user,
      manager: manager
    }
  end

  describe "Employee" do
    test "Get clock of an another user", %{
      conn_user: conn_user,
      conn_manager: conn_manager,
      user: user,
      manager: manager
    } do
      conn = get(conn_user, "/api/clocks/#{manager.id}")
      assert response(conn, 404)
    end

    test "Create clock", %{
      conn_user: conn_user,
      user: user,
      manager: manager
    } do
      conn = post(conn_user, "/api/clocks/#{manager.id}")
      assert response(conn, 403)
    end

    test "Get his own clock", %{
      conn_user: conn_user,
      user: user
    } do
      conn = post(conn_user, "/api/me/clock")
      assert response(conn, 201)

      conn = get(conn_user, "/api/clocks/#{user.id}")
      assert response(conn, 200)
    end
  end

  describe "Manager" do
    test "Get clock of an another user", %{
      conn_manager: conn_manager,
      conn_user: conn_user,
      user: user,
      manager: manager
    } do
      conn = post(conn_user, "/api/me/clock")
      assert response(conn, 201)
    end
  end
end
