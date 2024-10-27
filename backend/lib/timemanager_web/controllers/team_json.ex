defmodule TimeManagerWeb.TeamJSON do
  alias TimeManager.Teams.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team, %{associations: true})}
  end

  defp data(%Team{} = team, options \\ %{}) do
    base_data = TimeManagerWeb.ModelToJson.serialize_data(team, options)

    if options[:associations] do
      # Ajout des clocks associés
      Map.put(base_data, :clocks, serialize_clocks(team.clocks))
    else
      base_data
    end
  end

  defp serialize_clocks(clocks) do
    Enum.map(clocks, fn clock ->
      %{id: clock.id, status: clock.status, time: clock.time, user_id: clock.user_id}
    end)
  end
end
