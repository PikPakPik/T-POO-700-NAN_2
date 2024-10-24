defmodule TimeManager.UsersTest do
  use TimeManager.DataCase

  alias TimeManager.Users

  describe "users" do
    alias TimeManager.Users.User

    import TimeManager.UsersFixtures

    @invalid_attrs %{username: nil, email: nil, role_id: 1, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      params = %{toto: "toto", mail: "toto@mail.com"}
      assert Users.list_users(params) == [user]
      nilParams = %{}
      assert Users.list_users(nilParams) == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_role = %{name: "Employee", permissions: %{"working_time" => ["read"]}}
      {:ok, role} = TimeManager.Roles.create_role(valid_role)

      valid_attrs = %{
        username: "toto",
        email: "toto@mail.com",
        password: "password",
        role_id: role.id
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.username == "toto"
      assert user.email == "toto@mail.com"
      assert user.role_id == role.id
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "titi", email: "titiEtGrominet@mail.com"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.username == "titi"
      assert user.email == "titiEtGrominet@mail.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
