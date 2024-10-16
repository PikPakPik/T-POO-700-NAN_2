defmodule TimeManager.WorkingTimesTest do
  use TimeManager.DataCase

  alias TimeManager.WorkingTimes
  alias TimeManager.Users

  describe "workingtimes" do
    alias TimeManager.WorkingTimes.WorkingTime
    alias TimeManager.Users.User

    import TimeManager.WorkingTimesFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert WorkingTimes.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert WorkingTimes.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      role_attrs = %{name: "User", description: "Standard user role"}
      {:ok, role} = TimeManager.Roles.create_role(role_attrs)
      user_attrs = %{username: "toto", email: "toto@mail.com", role_id: role.id}
      {:ok, user} = TimeManager.Users.create_user(user_attrs)
      assert user.username == "toto"
      assert user.email == "toto@mail.com"
      assert user.role_id == role.id

      valid_workingTime = %{
        start: ~U[2024-10-07 07:55:00Z],
        end: ~U[2024-10-07 07:55:00Z],
        user_id: user.id
      }

      assert {:ok, %WorkingTime{} = working_time} =
               WorkingTimes.create_working_time(valid_workingTime)

      assert working_time.start == ~U[2024-10-07 07:55:00Z]
      assert working_time.end == ~U[2024-10-07 07:55:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTimes.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2024-10-08 07:55:00Z], end: ~U[2024-10-08 07:55:00Z]}

      assert {:ok, %WorkingTime{} = working_time} =
               WorkingTimes.update_working_time(working_time, update_attrs)

      assert working_time.start == ~U[2024-10-08 07:55:00Z]
      assert working_time.end == ~U[2024-10-08 07:55:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()

      assert {:error, %Ecto.Changeset{}} =
               WorkingTimes.update_working_time(working_time, @invalid_attrs)

      assert working_time == WorkingTimes.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = WorkingTimes.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkingTimes.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = WorkingTimes.change_working_time(working_time)
    end
  end
end
