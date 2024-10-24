defmodule TimeManagerWeb.ClockJSON do
  alias TimeManager.Clocks.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock, %{associations: true})}
  end

  defp data(%Clock{} = clock, options \\ %{}) do
    TimeManagerWeb.ModelToJson.serialize_data(clock, options)
  end
end
