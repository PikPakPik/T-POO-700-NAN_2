defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.WorkingTimes.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(working_time <- workingtimes, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time, %{associations: true})}
  end

  defp data(%WorkingTime{} = working_time, options \\ %{}) do
    TimeManagerWeb.ModelToJson.serialize_data(working_time, options)
  end
end
