defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManagerWeb.SwaggerDef
  alias TimeManagerWeb.Plugs.PermissionPlug
  alias TimeManager.Auth

  action_fallback(TimeManagerWeb.FallbackController)

  plug(PermissionPlug,
    actions: [
      get_user_clock: %{"user" => ["read"]},
      clock_in_out_user: %{"user" => ["clock"]},
      index: %{"clock" => ["read"]},
      delete: %{"clock" => ["delete"]}
    ]
  )

  def swagger_definitions do
    SwaggerDef.clock_definitions()
  end

  swagger_path(:index) do
    summary("List Clocks")
    description("List all clocks in the database.")

    SwaggerDef.api_protected_path()

    response(200, "OK", Schema.ref(:ClocksResponse))
  end

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  swagger_path(:clock_in_out_user) do
    summary("Clock in or out user")
    description("Clock in or out a user.")

    SwaggerDef.api_protected_path()

    parameters do
      userID(:path, :integer, "User ID", required: true, example: 1)
    end

    response(200, "OK", Schema.ref(:ClockResponse))
    response(201, "Created Successfully", Schema.ref(:ClockResponse))
  end

  def clock_in_out_user(conn, %{"userID" => userID}) do
    user = Auth.get_user(conn)

    if user.id != userID and user.role.name != "Admin" do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        403,
        Jason.encode!(%{error: %{message: "You can only clock in or out yourself"}})
      )
      |> halt()
    end

    with {status, {:ok, %Clock{} = clock}} <- Clocks.clock_in_out_user(userID) do
      case status do
        :created -> put_status(conn, :created)
        _ -> put_status(conn, 200)
      end
      |> render(:show, clock: clock)
    end
  end

  swagger_path(:get_user_clock) do
    summary("Show Clock")
    description("Show a clock by User ID.")

    SwaggerDef.api_protected_path()

    parameters do
      userID(:path, :integer, "User ID", required: true, example: 3)
    end

    response(200, "OK", Schema.ref(:ClockResponse))
  end

  def get_user_clock(conn, %{"userID" => user_id}) do
    user = Auth.get_user(conn)

    if user.role.name != "Admin" and user.id != user_id do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        403,
        Jason.encode!(%{error: %{message: "You can only see your own clock"}})
      )
      |> halt()
    end

    case clocks = Clocks.list_clocks_by_user_id(user_id) do
      [] -> {:error, :not_found}
      clocks -> render(conn, :index, clocks: clocks)
    end
  end

  swagger_path(:delete) do
    summary("Delete Clock")
    description("Delete a clock by ID.")
    parameter(:id, :path, :integer, "Clock ID", required: true, example: 3)

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
