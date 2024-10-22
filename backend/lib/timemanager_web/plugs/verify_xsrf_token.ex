defmodule TimeManagerWeb.Plugs.VerifyXSRFToken do
  import Plug.Conn
  require Logger

  alias TimeManager.Auth

  def init(default), do: default

  def call(conn, _opts) do
    conn = fetch_cookies(conn)
    xsrf_token = get_req_header(conn, "c-xsrf-token") |> List.first()
    jwt = conn.cookies["jwt"]

    cond do
      jwt == nil ->
        Logger.error("JWT is missing")

        conn
        |> send_resp(:unauthorized, "Invalid credentials")
        |> halt()

      xsrf_token == nil ->
        Logger.error("XSRF Token is missing")

        conn
        |> send_resp(:forbidden, "Missing XSRF token")
        |> halt()

      true ->
        try do
          case Auth.verify_jwt(jwt, xsrf_token) do
            {:ok, _claims} ->
              conn

            {:error, reason} ->
              conn
              |> send_resp(:forbidden, "Invalid XSRF token")
              |> halt()
          end
        rescue
          exception ->
            conn
            |> send_resp(:internal_server_error, "Internal server error")
            |> halt()
        end
    end
  end
end
