defmodule TimeManager.WorkingTimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.WorkingTimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "employee"
      })
      |> TimeManager.Roles.create_role()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "toto@mail.com",
        username: "toto",
        role_id: role.id
      })
      |> TimeManager.Users.create_user()

    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: NaiveDateTime.utc_now(),
        start: NaiveDateTime.utc_now(),
        user_id: user.id
      })
      |> TimeManager.WorkingTimes.create_working_time()

    working_time
  end
end
