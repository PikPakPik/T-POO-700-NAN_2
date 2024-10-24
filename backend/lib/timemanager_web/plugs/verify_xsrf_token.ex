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
        |> put_resp_content_type("application/json")
        |> send_resp(:unauthorized, "{\"error\": \"Invalid credentials\"}")
        |> halt()

      xsrf_token == nil ->
        Logger.error("XSRF Token is missing")

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(:forbidden, "{\"error\": \"Missing XSRF token\"}")
        |> halt()

      true ->
        try do
          case Auth.verify_jwt(jwt, xsrf_token) do
            {:ok, _claims} ->
              conn

            {:error, reason} ->
              Logger.error("JWT Verification Error: #{inspect(reason)}")

              conn
              |> put_resp_content_type("application/json")
              |> send_resp(:forbidden, "{\"error\": \"Invalid XSRF token\"}")
              |> halt()
          end
        rescue
          exception ->
            Logger.error("Exception occurred: #{inspect(exception)}")

            conn
            |> put_resp_content_type("application/json")
            |> send_resp(:internal_server_error, "{\"error\": \"Internal server error\"}")
            |> halt()
        end
    end
  end
end
