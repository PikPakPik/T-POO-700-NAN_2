defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    scope "/users" do
      resources "/", UserController, except: [:new, :edit, :create]
    end

    scope "/clocks" do
      resources "/", ClockController, except: [:new, :edit, :create]
    end

    scope "/workingtime" do
      resources "/", WorkingTimeController, except: [:new, :show, :create, :edit]
      get "/:userID", WorkingTimeController, :show_user_times
      get "/:userID/:id", WorkingTimeController, :show_user_time
    end

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
