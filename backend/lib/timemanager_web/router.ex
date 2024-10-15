defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/roles", RoleController, only: [:index, :show]

    scope "/users" do
      resources "/", UserController, except: [:new, :edit]
      put "/:userID/role/:roleID", UserController, :set_role
    end

    scope "/clocks" do
      resources "/", ClockController, only: [:index, :delete]
      post "/:userID", ClockController, :clock_in_out_user
      get "/:userID", ClockController, :get_user_clock
    end

    scope "/workingtime" do
      resources "/", WorkingTimeController, except: [:new, :show, :create, :edit]
      get "/:userID", WorkingTimeController, :show_user_times
      get "/:userID/:id", WorkingTimeController, :show_user_time
      post "/:userID", WorkingTimeController, :create_user_time
    end

  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :timemanager,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Time Manager API"
      },
      definitions: TimeManagerWeb.SwaggerDef.global_definitions,
      consumes: ["application/json"],
      produces: ["application/json"]
    }
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
