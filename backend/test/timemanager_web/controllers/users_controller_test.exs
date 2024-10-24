defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase
  import TimeManager.UsersFixtures

  alias TimeManager.Auth
  alias TimeManager.Repo

  setup %{conn: conn} do
    user = employee_fixture() |> Repo.preload([:role])
    manager = manager_fixture() |> Repo.preload([:role])
    admin = admin_fixture() |> Repo.preload([:role])

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
      admin: admin
    }
  end

  describe "No authentication" do
    test "Get all users", %{conn: conn} do
      conn = get(conn, "/api/users")
      assert response(conn, 401)
    end

    test "Get user by id", %{conn: conn, user: user} do
      conn = get(conn, "/api/users/#{user.id}")
      assert response(conn, 401)
    end

    test "Login", %{conn: conn, user: user} do
      conn = post(conn, "/api/users/sign_in", %{email: user.email, password: "employee"})
      assert response(conn, 200)
    end
  end

  describe "Employee" do
    test "Get all users", %{conn_user: conn_user} do
      conn = get(conn_user, "/api/users")
      assert response(conn, 200)
    end

    test "Get user by id", %{conn_user: conn_user, user: user} do
      conn = get(conn_user, "/api/users/#{user.id}")
      assert response(conn, 200)
    end
  end

  describe "Manager" do
    test "Create user", %{conn_manager: conn_manager} do
      conn = post(conn_manager, "/api/users", %{email: "test@test.com", password: "test"})
      assert response(conn, 403)
    end

    test "Update user", %{conn_manager: conn_manager, user: user} do
      conn = put(conn_manager, "/api/users/#{user.id}", %{email: "test@test.com"})
      assert response(conn, 403)
    end

    test "Delete user", %{conn_manager: conn_manager, user: user} do
      conn = delete(conn_manager, "/api/users/#{user.id}")
      assert response(conn, 403)
    end

    test "Get user by id", %{conn_manager: conn_manager, user: user} do
      conn = get(conn_manager, "/api/users/#{user.id}")
      assert response(conn, 200)
    end

    test "Update Role", %{conn_manager: conn_manager, user: user, admin: admin} do
      conn = put(conn_manager, "/api/users/#{user.id}/role/#{admin.role.id}")
      assert response(conn, 403)
    end
  end

  describe "Admin" do
    test "Create user", %{conn_admin: conn_admin, admin: admin} do
      conn =
        post(conn_admin, "/api/users", %{
          user: %{
            username: "test",
            email: "test@test.com",
            password: "test",
            role_id: admin.role.id
          }
        })

      assert response(conn, 201)

      assert Repo.get_by(TimeManager.Users.User, email: "test@test.com")
    end

    test "Update user", %{conn_admin: conn_admin, user: user} do
      conn = put(conn_admin, "/api/users/#{user.id}", %{user: %{email: "test@test.com"}})
      assert response(conn, 200)
    end

    test "Delete user", %{conn_admin: conn_admin, user: user} do
      conn = delete(conn_admin, "/api/users/#{user.id}")
      assert response(conn, 204)
    end

    test "Update Role", %{conn_admin: conn_admin, user: user, admin: admin} do
      conn = put(conn_admin, "/api/users/#{user.id}/role/#{admin.role.id}")
      assert response(conn, 200)
    end
  end
end
