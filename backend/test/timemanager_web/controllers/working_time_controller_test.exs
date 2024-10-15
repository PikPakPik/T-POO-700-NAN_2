defmodule TimeManagerWeb.WorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkingTimesFixtures

  alias TimeManager.WorkingTimes.WorkingTime

  @create_attrs %{
    end: ~N[2024-10-23 08:39:00],
    start: ~N[2024-10-23 08:39:00],
    user_id: 1
  }
  @update_attrs %{
    end: ~N[2024-10-24 08:39:00],
    start: ~N[2024-10-24 08:39:00],
    user_id: 1
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtime")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    # test "renders working_time when data is valid", %{conn: conn} do
    #   # create a user
    #   role_attrs = %{name: "User"}
    #   {:ok, role} = TimeManager.Roles.create_role(role_attrs)
    #   user_attrs = %{username: "toto", email: "toto@mail.com", role_id: role.id}
    #   {:ok, user} = TimeManager.Users.create_user(user_attrs)

    #   # create a working time on userId api/workingtime/:userID
    #   conn = post(conn, ~p"/api/workingtime/#{user.id}", working_time: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   # Ensure the working time is created before fetching
    #   conn = get(conn, ~p"/api/workingtime/#{user.id}/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "end" => "2024-10-23T08:39:00",
    #            "start" => "2024-10-23T08:39:00"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/workingtime", working_time: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update working_time" do
    setup [:create_working_time]

    # test "renders working_time when data is valid", %{
    #   conn: conn,
    #   working_time: %WorkingTime{id: id} = working_time
    # } do
    #   conn = put(conn, ~p"/api/workingtime/#{working_time}", working_time: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/workingtime/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "end" => "2024-10-24T08:39:00",
    #            "start" => "2024-10-24T08:39:00"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
    #   conn = put(conn, ~p"/api/workingtime/#{working_time}", working_time: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    # test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
    #   conn = delete(conn, ~p"/api/workingtime/#{working_time.id}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/workingtime/#{working_time}")
    #   end
    # end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
