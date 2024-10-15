defmodule TimeManager.RoleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Role` context.
  """

  @doc """
  Generate a roles.
  """
  def roles_fixture(attrs \\ %{}) do
    {:ok, roles} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManager.Role.create_roles()

    roles
  end
end
