defmodule TimeManagerWeb.LogController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Logs
  alias TimeManager.Logs.Log
  alias TimeManagerWeb.SwaggerDef

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    SwaggerDef.log_definitions()
  end

  swagger_path(:index) do
    summary("List Logs")
    description("List all logs in the database.")

    response(200, "OK", Schema.ref(:LogsResponse))
  end
  def index(conn, _params) do
    logs = Logs.list_logs()
    render(conn, :index, logs: logs)
  end

  swagger_path(:show) do
    summary("Show Log")
    description("Show a log by ID.")
    parameter(:id, :path, :integer, "Log ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:LogResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show(conn, %{"id" => id}) do
    log = Logs.get_log!(id)
    render(conn, :show, log: log)
  end
end
