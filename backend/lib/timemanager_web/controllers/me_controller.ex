defmodule TimeManagerWeb.MeController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock
  alias TimeManagerWeb.SwaggerDef
  alias TimeManager.Auth
  alias TimeManagerWeb.Plugs.PermissionPlug

  action_fallback(TimeManagerWeb.FallbackController)

  plug(PermissionPlug,
    actions: [
      show: %{"me" => ["read"]},
      working_times: %{"me" => ["read"]},
      update: %{"me" => ["update"]},
      delete: %{"me" => ["delete"]},
      clock: %{"me" => ["clock"]},
      teams: %{"me" => ["read"]},
      get_clock: %{"me" => ["clock"]}
    ]
  )

  def swagger_definitions do
    SwaggerDef.user_definitions()
  end

  swagger_path(:index) do
    summary("Get current user")
    description("Get the current user")

    SwaggerDef.api_protected_path()

    response(200, "OK", Schema.ref(:UserResponse))
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def index(conn, _params) do
    case Auth.get_user(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User not found or token invalid."})

      user ->
        conn
        |> json(%{user: user})
    end
  end

  swagger_path(:update) do
    summary("Update current user")
    description("Update the current user")

    SwaggerDef.api_protected_path()

    parameters do
      user(:body, Schema.ref(:UserRequest), "The user details")
    end

    response(200, "OK", Schema.ref(:UserResponse))
    response(400, "Bad Request", Schema.ref(:BadRequestResponse))
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def update(conn, %{"user" => user_params}) do
    user = Auth.get_user(conn)

    with {:ok, %User{} = user} <- TimeManager.Users.update_user(user, user_params) do
      conn
      |> put_view(json: TimeManagerWeb.UserJSON)
      |> render(:show, user: user)
    end
  end

  swagger_path(:delete) do
    summary("Delete current user")
    description("Delete the current user")

    SwaggerDef.api_protected_path()

    response(204, "No Content")
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def delete(conn, _params) do
    user = Auth.get_user(conn)

    with {:ok, _} <- TimeManager.Users.delete_user(user) do
      conn |> put_status(:no_content) |> text("")
    end
  end

  swagger_path(:get_clock) do
    summary("Get current user clock")
    description("Get the current user clock")

    SwaggerDef.api_protected_path()
  end

  def get_clock(conn, _params) do
    user = Auth.get_user(conn)
    clock = TimeManager.Clocks.get_user_clock(user.id)
    conn |> json(%{clock: clock})
  end

  swagger_path(:clock) do
    summary("Clock in or out")
    description("Clock in or out")

    SwaggerDef.api_protected_path()

    response(200, "OK", Schema.ref(:ClockResponse))
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def clock(conn, params) do
    with {status, {:ok, %TimeManager.Clocks.Clock{} = clock}} <-
           TimeManager.Clocks.clock_in_out_user(Auth.get_user_id(conn)) do
      case status do
        :created -> put_status(conn, :created)
        _ -> put_status(conn, 200)
      end
      |> put_view(json: TimeManagerWeb.ClockJSON)
      |> render(:show, clock: clock)
    end
  end

  swagger_path(:working_times) do
    summary("Get working times")
    description("Get working times")

    SwaggerDef.api_protected_path()

    parameter(:start, :query, :string, "Period start (default to no limit)",
      required: false,
      example: "2023-02-04 11:24:45",
      format: :utc_datetime
    )

    parameter(:end, :query, :string, "Period end (default to no limit)",
      required: false,
      example: "2023-02-04 11:24:45",
      format: :utc_datetime
    )

    response(200, "OK", Schema.ref(:WorkingTimeResponse))
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def working_times(conn, params) do
    working_times =
      params
      |> Map.put("userID", Auth.get_user_id(conn))
      |> TimeManager.WorkingTimes.get_user_working_times!()

    conn
    |> put_view(json: TimeManagerWeb.WorkingTimeJSON)
    |> render(:index, workingtimes: working_times)
  end

  swagger_path(:teams) do
    summary("Get teams")
    description("Get teams where the current user is a member or a manager")

    SwaggerDef.api_protected_path()

    response(200, "OK", Schema.ref(:TeamResponse))
    response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def teams(conn, _params) do
    user = Auth.get_user(conn)
    employee_teams_ids = TimeManager.Teams.get_employee_teams!(user.id) |> Enum.map(& &1.team_id)
    managing_teams_ids = TimeManager.Teams.get_managing_teams!(user.id) |> Enum.map(& &1.team_id)

    employee_teams = Enum.map(employee_teams_ids, &TimeManager.Teams.get_team!/1)
    managing_teams = Enum.map(managing_teams_ids, &TimeManager.Teams.get_team!/1)

    employee_teams = TimeManagerWeb.TeamJSON.index(%{teams: employee_teams})
    managing_teams = TimeManagerWeb.TeamJSON.index(%{teams: managing_teams})

    conn |> json(%{employee_teams: employee_teams, managing_teams: managing_teams})
  end
end
