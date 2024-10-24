defmodule TimeManager.RolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Roles` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        name: "employee",
        permissions: %{
          "me" => ["read", "update", "delete", "clock"],
          "user" => ["read"],
          "role" => ["read"]
        }
      })
      |> TimeManager.Roles.create_role()

    employee
  end

  def manager_fixture(attrs \\ %{}) do
    {:ok, manager} =
      attrs
      |> Enum.into(%{
        name: "manager",
        permissions: %{
          "me" => ["read", "update"],
          "user" => ["read", "update"],
          "role" => ["read", "update"]
        }
      })
      |> TimeManager.Roles.create_role()

    manager
  end

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        name: "admin",
        permissions: %{
          "me" => ["read", "update", "delete", "create"],
          "user" => ["read", "update", "delete", "create"],
          "role" => ["read", "update", "delete", "create"]
        }
      })
      |> TimeManager.Roles.create_role()

    admin
  end
end
