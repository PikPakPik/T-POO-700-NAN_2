defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ClocksFixtures

  alias TimeManager.Clocks.Clock

  @create_attrs %{
    status: true
  }
  @create_user %{
    username: "toto",
    email: "toto@mail.com",
    role_id: 1
  }
  @update_attrs %{
    status: false,
    time: ~U[2024-10-08 07:55:00Z]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      conn = get(conn, ~p"/api/clocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      # create a user
      conn = post(conn, ~p"/api/users", user: @create_user)
      assert %{"id" => userID} = json_response(conn, 201)["data"]

      # create a clock
      conn = post(conn, ~p"/api/clocks/#{userID}", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{userID}")

      time_now = DateTime.utc_now()

      assert %{
               "status" => true,
               "time" => time_now,
               "user_id" => userID,
               "id" => id
             } = hd(json_response(conn, 200)["data"])
    end
  end
end
