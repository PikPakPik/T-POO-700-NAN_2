defmodule TimeManager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "employee",
        permissions: %{"working_time" => ["read"]}
      })
      |> TimeManager.Roles.create_role()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "toto@mail.com",
        username: "toto",
        password: "password",
        role_id: role.id
      })
      |> TimeManager.Users.create_user()

    user
  end
end
