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
    %{data: data(log, %{associations: true})}
  end

  defp data(%Log{} = log, options \\ %{}) do
    TimeManagerWeb.ModelToJson.serialize_data(log, options)
  end
end
