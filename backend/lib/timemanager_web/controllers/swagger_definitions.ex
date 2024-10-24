defmodule TimeManagerWeb.SwaggerDef do
  use PhoenixSwagger
  alias PhoenixSwagger.Path

  def api_protected_path(%Path.PathObject{} = path) do
    path
    |> Path.security([%{"csrf" => []}])
    |> Path.response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

  def global_definitions do
    %{
      ErrorReason:
        swagger_schema do
          title("ErrorReason")
          description("An error")

          properties do
            _type(:string, "Error type")
            message(:string, "Error message")
            stack(Schema.array(:string), "Error stack trace. Only in debug mode")
          end

          example(%{
            _type: "Elixir.Ecto.NoResultsError",
            message: "expected at least one result but got none"
          })
        end,
      # 400
      BadRequestResponse:
        swagger_schema do
          title("BadRequestResponse")
          description("Bad request")

          properties do
            reason(:ErrorReason, "Error reason")
          end
        end,
      # 403
      ForbiddenResponse:
        swagger_schema do
          title("ForbiddenResponse")
          description("Forbidden")

          properties do
            reason(:ErrorReason, "Error reason")
          end
        end,
      # 404
      NotFoundResponse:
        swagger_schema do
          title("NotFoundResponse")
          description("Resource not found")

          properties do
            reason(:ErrorReason, "Error reason")
          end
        end,
      # 422
      UnprocessableEntityResponse:
        swagger_schema do
          title("UnprocessableEntityResponse")
          description("Unprocessable entity")

          properties do
            reason(:ErrorReason, "Error reason")
          end
        end
    }
  end

  def user_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("User schema")

          properties do
            id(:integer, "User ID")
            username(:string, "User username")
            email(:string, "Email address", format: :email)
          end

          example(%{
            id: 1,
            username: "JohnDoe",
            email: "john@doe.com"
          })
        end,
      UserLogin:
        swagger_schema do
          title("UserLogin")
          description("User login schema")

          properties do
            email(:string, "Email address", format: :email)
            password(:string, "Password")
          end
        end,
      UserDetailed:
        swagger_schema do
          title("UserDetailed")
          description("User schema with its associations")

          properties do
            id(:integer, "User ID")
            username(:string, "User username")
            email(:string, "Email address", format: :email)
            clock(Schema.ref(:Clock), "User clock", "x-nullable": true)
            working_times(Schema.array(:WorkingTime), "User working times")
          end

          example(%{
            id: 1,
            username: "JohnDoe",
            email: "john@doe.com",
            clock: %{
              id: 1,
              user_id: 1,
              time: "2024-10-08 10:05:01",
              status: false
            },
            working_times: [
              %{
                id: 1,
                user_id: 1,
                start: "2024-10-08 10:05:01",
                end: "2024-10-08 10:05:01"
              }
            ]
          })
        end,
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("PUT body for updating a user")
          property(:user, Schema.ref(:User), "The user details")

          example(%{
            user: %{
              username: "JohnDoe",
              email: "john@doe.com"
            }
          })
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, Schema.ref(:UserDetailed), "The user details")
        end,
      UsersResponse:
        swagger_schema do
          title("UsersResponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User), "The users list")
        end
    }
  end

  def clock_definitions do
    %{
      Clock:
        swagger_schema do
          title("Clock")
          description("Clock schema")

          properties do
            id(:integer, "Clock ID")
            user_id(:integer, "User ID")
            time(:string, "Clock time", format: :utc_datetime)
            status(:boolean, "Clock status")
          end

          example(%{
            id: 1,
            user_id: 1,
            time: "2024-10-08 10:05:01",
            status: false
          })
        end,
      WorkingTimeRequest:
        swagger_schema do
          title("WorkingTimeRequest")
          description("Request body when creating a working time")

          properties do
            user_id(:integer, "Associated user id")
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Working time end time", format: :utc_datetime)
          end

          example(%{
            working_time: %{
              user_id: 1,
              start: "2024-10-08 10:05:01",
              end: "2024-10-08 10:05:01"
            }
          })
        end,
      ClocksResponse:
        swagger_schema do
          title("ClocksReponse")
          description("Response schema for multiple clocks")
          property(:data, Schema.array(:Clock), "The clocks details")
        end,
      ClockResponse:
        swagger_schema do
          title("ClockResponse")
          description("Response schema for single clock")
          property(:data, Schema.ref(:Clock), "The clock details")
        end
    }
  end

  def working_time_definitions do
    %{
      WorkingTime:
        swagger_schema do
          title("WorkingTime")
          description("Working time schema")

          properties do
            id(:integer, "Working time ID")
            user_id(:integer, "User ID")
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Working time end time", format: :utc_datetime)
          end

          example(%{
            id: 1,
            user_id: 1,
            start: "2024-10-08 10:05:01",
            end: "2024-10-08 10:05:01"
          })
        end,
      UserWorkingTimeRequest:
        swagger_schema do
          title("UserWorkingTimeRequest")
          description("Request body when creating a user working time")

          properties do
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Workinng time end time", format: :utc_datetime)
          end

          example(%{
            working_time: %{
              start: "2024-10-08 10:05:01",
              end: "2024-10-08 10:05:01"
            }
          })
        end,
      WorkingTimeResponse:
        swagger_schema do
          title("WorkingTimeResponse")
          description("Response schema for single working time")
          property(:data, Schema.ref(:WorkingTime), "The working time details")
        end,
      WorkingTimesResponse:
        swagger_schema do
          title("WorkingTimesResponse")
          description("Response schema for multiple working times")
          property(:data, Schema.array(:WorkingTime), "The working times list")
        end
    }
  end

  def role_definitions do
    %{
      Role:
        swagger_schema do
          title("Role")
          description("Role. Default roles are: Admin, Manager and Employee")

          properties do
            id(:integer, "Role ID")
            name(:string, "Role name")
          end

          example(%{
            id: 4,
            name: "Employee",
            permissions: %{}
          })
        end,
      RoleDetailed:
        swagger_schema do
          title("RoleDetailed")
          description("Role. Default roles are: Admin, Manager and Employee")

          properties do
            id(:integer, "Role ID")
            name(:string, "Role name")
            users(Schema.array(:User), "Users with the requested role")
          end

          example(%{
            id: 1,
            name: "Employee",
            users: []
          })
        end,
      RoleResponse:
        swagger_schema do
          title("RoleResponse")
          description("Response schema for single role")
          property(:data, Schema.ref(:Role), "The role details")
        end,
      RolesResponse:
        swagger_schema do
          title("RolesResponse")
          description("Response schema for multiple roles")
          property(:data, Schema.array(:Role), "The roles list")
        end
    }
  end

  def team_definitions do
    %{
      Team:
        swagger_schema do
          title("Team")
          description("A team of employees managed by one or multiple managers.")

          properties do
            id(:integer, "Team ID")
            name(:string, "Team name")
          end

          example(%{
            id: 1,
            name: "Team A"
          })
        end,
      TeamDetailed:
        swagger_schema do
          title("TeamDetailed")
          description("A team of employees managed by one or multiple managers.")

          properties do
            id(:integer, "Team ID")
            name(:string, "Team name")
            employees(Schema.array(:User), "Team employees")
            managers(Schema.array(:User), "Team managers")
          end

          example(%{
            id: 1,
            name: "Team Day",
            employees: [],
            managers: []
          })
        end,
      TeamRequest:
        swagger_schema do
          title("TeamRequest")
          description("A team request for team creation.")

          properties do
            name(:string, "Team name")
          end

          example(%{
            team: %{
              name: "Team Day"
            }
          })
        end,
      TeamResponse:
        swagger_schema do
          title("TeamResponse")
          description("Response schema for single team")
          property(:data, Schema.ref(:TeamDetailed), "The team details")
        end,
      TeamsResponse:
        swagger_schema do
          title("TeamsResponse")
          description("Response schema for multiple teams")
          property(:data, Schema.array(:Team), "The teams list")
        end,
      TeamClockResponse:
        swagger_schema do
          title("TeamClockResponse")
          description("Response schema for a team clock")
          property(:data, Schema.array(:Clock), "The team users' clocks'")
        end
    }
  end

  def log_definitions do
    %{
      Log:
        swagger_schema do
          title("Log")
          description("Log schema")

          properties do
            id(:integer, "Log ID")
            user_id(:integer, "User ID")
            time(:string, "Log time", format: :utc_datetime)
            action(:string, "Log action")
          end

          example(%{
            id: 1,
            user_id: 1,
            time: "2024-10-08 10:05:01",
            action: "user:create"
          })
        end,
      LogsResponse:
        swagger_schema do
          title("LogsResponse")
          description("Response schema for multiple logs")
          property(:data, Schema.array(:Log), "The logs details")
        end,
      LogResponse:
        swagger_schema do
          title("LogResponse")
          description("Response schema for single log")
          property(:data, Schema.ref(:Log), "The log details")
        end
    }
  end
end
