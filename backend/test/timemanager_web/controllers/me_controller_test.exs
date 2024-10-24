defmodule TimeManagerWeb.MeControllerTest do
  use TimeManagerWeb.ConnCase
  import TimeManager.UsersFixtures

  alias TimeManager.Auth
  alias TimeManager.Repo
  alias TimeManager.WorkingTimes.WorkingTime

  setup %{conn: conn} do
    user = employee_fixture() |> Repo.preload([:role])
    {jwt, xsrf} = Auth.generate_jwt(user)

    conn =
      conn
      |> put_req_cookie("jwt", jwt)
      |> put_req_header("c-xsrf-token", xsrf)
      |> put_req_header("accept", "application/json")

    %{conn: conn, user: user}
  end

  describe "index action" do
    test "returns the current user when authenticated", %{conn: conn, user: user} do
      conn = assign(conn, :current_user, user)
      conn = get(conn, "/api/me")

      expected_user = %{
        "id" => user.id,
        "username" => user.username,
        "role" => %{
          "id" => user.role.id,
          "name" => user.role.name
        },
        "email" => user.email
      }

      assert json_response(conn, 200)["user"] == expected_user
    end

    test "returns unauthorized if no user is found", %{conn: conn} do
      conn = conn |> put_req_header("x-xsrf-token", "invalid")
      conn = conn |> put_req_cookie("jwt", "invalid_token")

      conn = get(conn, "/api/me")
      assert response(conn, 403)
    end
  end

  describe "update action" do
    test "returns the updated user when authenticated", %{conn: conn, user: user} do
      correct_values = %{"user" => %{username: "test", email: "test@test.com"}}
      conn = assign(conn, :current_user, user)
      conn = put(conn, "/api/me", correct_values)
      assert response(conn, 200)
    end

    test "return an error when the data is incorrect", %{conn: conn, user: user} do
      incorrect_values = %{"user" => %{username: "", email: "test@test.com"}}
      conn = assign(conn, :current_user, user)
      conn = put(conn, "/api/me", incorrect_values)
      assert response(conn, 422)
    end
  end

  describe "show my working time" do
    test "returns the user's working time when authenticated", %{conn: conn, user: user} do
      conn = assign(conn, :current_user, user)
      conn = get(conn, "/api/me/workingtimes")
      assert response(conn, 200)
    end
  end

  describe "the user can clock himself" do
    test "If no clock record, create the clock with status true", %{conn: conn, user: user} do
      conn = assign(conn, :current_user, user)
      conn = post(conn, "/api/me/clock")
      assert response(conn, 201)
      assert json_response(conn, 201)["data"]["status"] == true
    end

    test "If there is a clock record, update the clock with status false", %{
      conn: conn,
      user: user
    } do
      conn = assign(conn, :current_user, user)
      conn_1 = post(conn, "/api/me/clock")
      assert response(conn_1, 201)
      assert json_response(conn_1, 201)["data"]["status"] == true

      conn_2 = assign(conn, :current_user, user)
      conn_2 = post(conn_2, "/api/me/clock")
      assert response(conn_2, 200)
      assert json_response(conn_2, 200)["data"]["status"] == false
    end

    test "When the user clocks out, a working time record is created with start and end time", %{
      conn: conn,
      user: user
    } do
      conn = assign(conn, :current_user, user)
      conn_1 = post(conn, "/api/me/clock")
      start = json_response(conn_1, 201)["data"]["time"]

      start_datetime = nil
      ends_datetime = nil

      # Attempt to parse with timezone, default to UTC if missing
      case DateTime.from_iso8601(start) do
        {:ok, datetime, _} ->
          start_datetime = datetime

        {:error, :missing_offset} ->
          start_datetime = DateTime.from_iso8601(start <> "Z") |> elem(1)
      end

      # Convert start_datetime to ISO8601 string if not nil
      if start_datetime do
        start = DateTime.to_iso8601(start_datetime)
      end

      assert response(conn_1, 201)
      assert json_response(conn_1, 201)["data"]["status"] == true

      conn_2 = assign(conn, :current_user, user)
      conn_2 = post(conn_2, "/api/me/clock")
      ends = json_response(conn_2, 200)["data"]["time"]

      # Attempt to parse with timezone, default to UTC if missing
      case DateTime.from_iso8601(ends) do
        {:ok, datetime, _} -> ends_datetime = datetime
        {:error, :missing_offset} -> ends_datetime = DateTime.from_iso8601(ends <> "Z") |> elem(1)
      end

      # Convert ends_datetime to ISO8601 string if not nil
      if ends_datetime do
        ends = DateTime.to_iso8601(ends_datetime)
      end

      assert response(conn_2, 200)
      assert json_response(conn_2, 200)["data"]["status"] == false

      working_time = Repo.get_by(WorkingTime, user_id: user.id)
      assert working_time.start != nil
    end
  end

  describe "can get the teams of the user" do
    test "returns the user's teams when authenticated", %{conn: conn, user: user} do
      conn = assign(conn, :current_user, user)
      conn = get(conn, "/api/me/teams")
      assert response(conn, 200)
    end
  end

  describe "delete action" do
    test "returns the deleted user when authenticated", %{conn: conn, user: user} do
      conn = assign(conn, :current_user, user)
      conn = delete(conn, "/api/me")
      assert response(conn, 204)
    end
  end
end
