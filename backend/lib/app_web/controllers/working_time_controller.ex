defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts

  action_fallback TimeManagerWeb.FallbackController

  def show_user_times(conn, params) do
    working_times = Accounts.get_user_working_times!(params)

    render(conn, :index, working_times: working_times)
  end

  def show_user_time(conn, %{"userID" => userID, "id" => id}) do
    working_time = Accounts.get_user_working_time!(userID, id)

    render(conn, :show, working_time: working_time)
  end
end
