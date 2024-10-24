defmodule TimeManager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Users` context.
  """

  @doc """
  Generate a user.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "employee",
        permissions: %{
          "me" => ["read", "update", "delete", "clock"],
          "user" => ["read"],
          "role" => ["read"],
          "team" => ["read"]
        }
      })
      |> TimeManager.Roles.create_role()

    case TimeManager.Users.create_user(
           attrs
           |> Enum.into(%{
             email: Faker.Internet.email(),
             username: Faker.Internet.user_name(),
             password: "employee",
             role_id: role.id
           })
         ) do
      {:ok, user} -> user
      {:error, reason} -> raise "Failed to create user: #{inspect(reason)}"
      _unexpected -> raise "Unexpected result: #{inspect(_unexpected)}"
    end
  end

  def manager_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "Manager",
        permissions:
          Map.put(TimeManager.Roles.Default.base_permissions(), "team", [
            "create",
            "read",
            "update",
            "delete",
            "clock"
          ])
      })
      |> TimeManager.Roles.create_role()

    case TimeManager.Users.create_user(
           attrs
           |> Enum.into(%{
             email: Faker.Internet.email(),
             username: Faker.Internet.user_name(),
             password: "manager",
             role_id: role.id
           })
         ) do
      {:ok, user} -> user
      {:error, reason} -> raise "Failed to create manager: #{inspect(reason)}"
      _unexpected -> raise "Unexpected result: #{inspect(_unexpected)}"
    end
  end

  def admin_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "Admin",
        permissions: TimeManager.Roles.Permissions.all()
      })
      |> TimeManager.Roles.create_role()

    case TimeManager.Users.create_user(
           attrs
           |> Enum.into(%{
             email: Faker.Internet.email(),
             username: Faker.Internet.user_name(),
             password: "admin",
             role_id: role.id
           })
         ) do
      {:ok, user} -> user
      {:error, reason} -> raise "Failed to create admin: #{inspect(reason)}"
      _unexpected -> raise "Unexpected result: #{inspect(_unexpected)}"
    end
  end
end
