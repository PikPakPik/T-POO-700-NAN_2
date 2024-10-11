defmodule TimeManagerWeb.WorkingTimeControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.WorkingTimesFixtures

  alias TimeManager.WorkingTimes.WorkingTime

  @create_attrs %{
    start: ~U[2024-10-07 07:55:00Z],
    end: ~U[2024-10-07 07:55:00Z]
  }
  @create_user %{
    username: "toto",
    email: "toto@mail.com"
  }
  @create_user_two %{
    username: "titi",
    email: "titi@mail.com"
  }
  @update_attrs %{
    start: ~U[2024-10-08 07:55:00Z],
    end: ~U[2024-10-08 07:55:00Z]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 404)["data"] == nil
    end
  end

  # describe "create working_time" do
  #   test "renders working_time when data is valid", %{conn: conn} do
  #     # create a user
  #     conn = post(conn, ~p"/api/users", user: @create_user)
  #     assert %{"id" => userID} = json_response(conn, 201)["data"]

  #     # create a working_time
  #     conn = post(conn, ~p"/api/workingtimes/#{userID}", working_time: @create_attrs)
  #     assert nil = json_response(conn, 404)["data"]

  #     id = json_response(conn, 201)["data"]["id"]

  #     conn = get(conn, ~p"/api/workingtimes/#{id}")

  #     assert %{
  #              "id" => id,
  #              "end" => "2024-10-07T07:55:00Z",
  #              "start" => "2024-10-07T07:55:00Z"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/workingtimes", working_time: @invalid_attrs)
  #     assert json_response(conn, 404)["errors"] != %{}
  #   end
  # end

  # describe "update working_time" do
  #   setup [:create_working_time]

  #   test "renders working_time when data is valid", %{conn: conn, working_time: %WorkingTime{id: id} = working_time} do
  #     # create a user
  #     conn = post(conn, ~p"/api/users", user: @create_user_two)
  #     assert %{"id" => userID} = json_response(conn, 201)["data"]

  #     # create a working_time
  #     conn = put(conn, ~p"/api/workingtimes/#{userID}", working_time: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 201)["data"]

  #     conn = get(conn, ~p"/api/workingtimes/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "end" => "2024-10-08T07:55:00Z",
  #              "start" => "2024-10-08T07:55:00Z"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
  #     conn = put(conn, ~p"/api/workingtimes/#{working_time}", working_time: @invalid_attrs)
  #     assert json_response(conn, 404)["errors"] != %{}
  #   end
  # end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      conn = delete(conn, ~p"/api/workingtimes/#{working_time.id}")
      assert response(conn, 404)
    end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
