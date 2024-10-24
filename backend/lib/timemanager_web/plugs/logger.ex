defmodule TimeManagerWeb.Plugs.Logger do
  import Plug.Conn
  alias TimeManager.Repo
  alias TimeManager.Logs.Log

  def init(defaults), do: defaults

  def call(conn, _opts) do
    user = TimeManager.Auth.get_user(conn)
    action = conn.method <> " " <> conn.request_path

    # Si l'utilisateur est connecté et que le role est admin ou manager
    if(user && (user.role.name == "Admin" || user.role.name == "Manager")) do
      %Log{
        action: action,
        user_id: user.id,
        time: DateTime.truncate(DateTime.utc_now(), :second),
        new_value: get_body(conn),
        old_value: %{details: "Some old values"}
      }
      |> Repo.insert()
    end

    conn
  end

  defp get_body(conn) do
    body = conn.body_params
    body = if body == %{}, do: conn.query_params, else: body
    body
  end
end
