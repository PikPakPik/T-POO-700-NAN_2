defmodule TimeManager.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "employee",
        permissions: %{
          "clock" => ["read"]
        }
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

    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: NaiveDateTime.utc_now(),
        user_id: user.id
      })
      |> TimeManager.Clocks.create_clock()

    clock
  end
end
