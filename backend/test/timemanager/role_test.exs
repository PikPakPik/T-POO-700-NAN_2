defmodule TimeManager.RoleTest do
  use TimeManager.DataCase

  alias TimeManager.Role

  describe "roles" do
    alias TimeManager.Roles.Role

    import TimeManager.RoleFixtures

    @invalid_attrs %{name: nil}

    test "list_roles/0 returns all roles" do
      roles = roles_fixture()
      assert Role.list_roles() == [roles]
    end

    test "get_roles!/1 returns the roles with given id" do
      roles = roles_fixture()
      assert Role.get_roles!(roles.id) == roles
    end

    test "create_roles/1 with valid data creates a roles" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Role{} = roles} = Role.create_roles(valid_attrs)
      assert roles.name == "some name"
    end

    test "create_roles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Role.create_roles(@invalid_attrs)
    end

    test "update_roles/2 with valid data updates the roles" do
      roles = roles_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Role{} = roles} = Role.update_roles(roles, update_attrs)
      assert roles.name == "some updated name"
    end

    test "update_roles/2 with invalid data returns error changeset" do
      roles = roles_fixture()
      assert {:error, %Ecto.Changeset{}} = Role.update_roles(roles, @invalid_attrs)
      assert roles == Role.get_roles!(roles.id)
    end

    test "delete_roles/1 deletes the roles" do
      roles = roles_fixture()
      assert {:ok, %Role{}} = Role.delete_roles(roles)
      assert_raise Ecto.NoResultsError, fn -> Role.get_roles!(roles.id) end
    end

    test "change_roles/1 returns a roles changeset" do
      roles = roles_fixture()
      assert %Ecto.Changeset{} = Role.change_roles(roles)
    end
  end
end
