defmodule TimeManagerWeb.LogJSON do
  alias TimeManager.Logs.Log

  @doc """
  Renders a list of logs.
  """
  def index(%{logs: logs}) do
    %{data: for(log <- logs, do: data(log))}
  end

  @doc """
  Renders a single log.
  """
  def show(%{log: log}) do
    %{data: data(log)}
  end

  defp data(%Log{} = log) do
    %{
      id: log.id,
      action: log.action,
      user_id: log.user_id,
      time: log.time
    }
  end
end
