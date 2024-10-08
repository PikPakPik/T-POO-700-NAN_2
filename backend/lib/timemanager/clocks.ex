defmodule TimeManager.Clocks do
  @moduledoc """
  The Clocks context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Repo

  alias TimeManager.Clocks.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  def list_clocks_by_user_id(user_id) do
    Clock
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  @doc """
  Get a user clock.
  """
  def get_user_clock(userID) do
    Clock
    |> where(user_id: ^userID)
    |> Repo.one()
  end

  @doc """
  Clock in or out a user.
  """
  def clock_in_out_user(userID) do
    now = DateTime.utc_now()

    case get_user_clock(userID) do
      nil -> create_new_clock(userID, now)
      %Clock{} = clock -> update_existing_clock(clock, now, userID)
    end
  end


  defp create_new_clock(userID, now) do
    {:created, create_clock(%{user_id: userID, status: true, time: now})}
  end

  defp update_existing_clock(clock, now, userID) do
    case clock.status do
      false -> {:updated, update_clock(clock, %{status: !clock.status, time: now})}
      true -> handle_active_clock(clock, userID, now)
    end
  end

  defp handle_active_clock(clock, userID, now) do
    with {:ok, %WorkingTime{} = _} <- WorkingTimes.create_working_time(%{user_id: userID, start: clock.time, end: now}) do
      {:updated, update_clock(clock, %{status: !clock.status, time: now})}
    end
  end
end
