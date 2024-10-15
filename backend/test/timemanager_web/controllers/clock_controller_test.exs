defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ClocksFixtures

  alias TimeManager.Clocks.Clock

  @create_attrs %{
    status: true,
    time: ~N[2024-10-23 07:36:00],
    user_id: 1
  }
  @update_attrs %{
    status: false,
    time: ~N[2024-10-24 07:36:00],
    user_id: 1
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

  # describe "create clock" do
  #   test "renders clock when data is valid", %{conn: conn} do
  #     role_attrs = %{name: "User", description: "Standard user role"}
  #     {:ok, role} = TimeManager.Roles.create_role(role_attrs)
  #     user_attrs = %{username: "toto", email: "toto@mail.com", role_id: role.id}
  #     {:ok, user} = TimeManager.Users.create_user(user_attrs)
  #     assert user.username == "toto"
  #     assert user.email == "toto@mail.com"
  #     assert user.role_id == role.id

  #     conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, ~p"/api/clocks/#{id}")

  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #   end

  #   # test "renders errors when data is invalid", %{conn: conn} do
  #   #   role_attrs = %{name: "User", description: "Standard user role"}
  #   #   {:ok, role} = TimeManager.Roles.create_role(role_attrs)
  #   #   user_attrs = %{username: "toto", email: "toto@mail.com", role_id: role.id}
  #   #   {:ok, user} = TimeManager.Users.create_user(user_attrs)
  #   #   assert user.username == "toto"
  #   #   assert user.email == "toto@mail.com"
  #   #   assert user.role_id == role.id
  #   #   conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_attrs)
  #   #   assert json_response(conn, 422)["errors"] != %{}
  #   # end
  # end

  # describe "delete clock" do
  #   setup [:create_clock]

  #   test "deletes chosen clock", %{conn: conn, clock: clock} do
  #     conn = delete(conn, ~p"/api/clocks/#{clock.id}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/clocks/#{clock}")
  #     end
  #   end
  # end

  defp create_clock(_) do
    clock = clock_fixture()
    %{clock: clock}
  end
end
