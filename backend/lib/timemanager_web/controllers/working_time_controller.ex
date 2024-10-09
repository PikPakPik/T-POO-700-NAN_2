defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManagerWeb.SwaggerDef
  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    SwaggerDef.working_time_definitions()
  end

  swagger_path(:index) do
    summary("List Working times")
    description("List all working times.")



    response(200, "OK", Schema.ref(:WorkingTimesResponse))
  end
  def index(conn, _params) do
    workingtimes = WorkingTimes.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  swagger_path(:create_user_time) do
    summary("Create user working time")
    description("Create a user working time entry.")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 1)
    parameter(:working_time, :body, Schema.ref(:WorkingTimeRequest), "Working time object", required: true)



    response(201, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def create_user_time(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    working_time_params_with_user = Map.put(working_time_params, "user_id", user_id)
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params_with_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  swagger_path(:show_user_times) do
    summary("List user working times")
    description("List working times of a given user.")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 1)
    parameter(:start, :query, :string, "Period start (default to no limit)", required: false, example: "2023-02-04 11:24:45", format: :utc_datetime)
    parameter(:end, :query, :string, "Period end (default to no limit)", required: false, example: "2023-02-14 16:28:42", format: :utc_datetime)



    response(200, "OK", Schema.ref(:WorkingTimesResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show_user_times(conn, params) do
    case working_times = WorkingTimes.get_user_working_times!(params) do
      [] -> {:error, :not_found}
      working_times -> render(conn, "index.json", workingtimes: working_times)
    end
  end

  swagger_path(:show_user_time) do
    summary("Show user working time")
    description("Show a specific user working time entry.")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 1)
    parameter(:id, :path, :integer, "Working time ID", required: true, example: 2)



    response(200, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show_user_time(conn, %{"id" => id, "userID" => userID}) do
    case working_time = WorkingTimes.get_user_working_time!(userID, id) do
      nil -> {:error, :not_found}
      working_time -> render(conn, :show, working_time: working_time)
    end
  end

  swagger_path(:update) do
    summary("Update working time")
    description("Update a working time entry.")

    parameter(:id, :path, :integer, "Working time ID", required: true, example: 1)
    parameter(:working_time, :body, Schema.ref(:WorkingTimeRequest), "Working time object", required: true)



    response(200, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  swagger_path(:delete) do
    summary("Delete Working time")
    description("Delete a working time by ID.")

    parameter(:id, :path, :integer, "Working time ID", required: true, example: 1)



    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
