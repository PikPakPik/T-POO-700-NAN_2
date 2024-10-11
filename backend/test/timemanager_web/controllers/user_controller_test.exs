defmodule TimeManagerWeb.UserControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.UsersFixtures

  alias TimeManager.Users.User

  @create_attrs %{
    username: "toto",
    email: "toto@mail.com"
  }
  @update_attrs %{
    username: "titi",
    email: "titiEtGrominet@mail.com"
  }
  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")

      assert nil == json_response(conn, 404)["data"]
    end
  end

  describe "get user by email and username" do
    test "retrieves user by email", %{conn: conn} do
      # create a user
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      # get user by email
      conn = get(conn, ~p"/api/users?email=toto@mail.com")
      assert [%{"id" => id, "email" => "toto@mail.com", "username" => "toto"}] = json_response(conn, 200)["data"]

      # get user by id
      conn = get(conn, ~p"/api/users/#{id}")
      assert %{"id" => id, "email" => "toto@mail.com", "username" => "toto"} = json_response(conn, 200)["data"]

      # get all users
      conn = get(conn, ~p"/api/users")
      assert [%{"id" => id, "email" => "toto@mail.com", "username" => "toto"}] = json_response(conn, 200)["data"]
    end
  end


  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "toto@mail.com",
               "username" => "toto"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "titiEtGrominet@mail.com",
               "username" => "titi"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
