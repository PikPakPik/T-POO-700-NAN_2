defmodule TimeManager.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Logs` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        action: "some action"
      })
      |> TimeManager.Logs.create_log()

    log
  end
end
