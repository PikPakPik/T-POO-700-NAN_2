defmodule TimeManager.RolesTest do
  use TimeManager.DataCase

  alias TimeManager.Roles
  alias TimeManager.Users

  describe "roles" do
    import TimeManager.RolesFixtures

    @valid_role_attrs %{name: "Employee", permissions: %{"clock" => ["read"]}}
    @invalid_role_attrs %{name: nil, permissions: %{}}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Roles.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Roles.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Roles.Role{} = role} = Roles.create_role(@valid_role_attrs)
      assert role.name == "Employee"
      assert role.permissions == %{"clock" => ["read"]}
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roles.create_role(@invalid_role_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{permissions: %{"clock" => ["read", "write"]}}

      assert {:ok, %Roles.Role{} = role} = Roles.update_role(role, update_attrs)
      assert role.permissions == %{"clock" => ["read", "write"]}
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Roles.update_role(role, @invalid_role_attrs)
      assert role == Roles.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Roles.Role{}} = Roles.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Roles.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Roles.change_role(role)
    end
  end
end
