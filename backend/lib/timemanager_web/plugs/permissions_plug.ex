defmodule TimeManagerWeb.Plugs.PermissionPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias TimeManager.Users.User
  alias TimeManager.Roles.Permissions

  def init(opts), do: opts

  def call(conn, opts) do
    user = TimeManager.Auth.get_user(conn)
    required_permission = get_required_permission(conn, opts)

    if required_permission == :error or
         (user != nil and Permissions.user_has_permission?(user, required_permission)) do
      conn
    else
      forbidden(conn)
    end
  end

  defp has_permission?(user_permissions, required_permissions) do
    Enum.all?(required_permissions, fn perm -> Map.has_key?(user_permissions, perm) end)
  end

  def forbidden(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      403,
      Jason.encode!(%{error: %{message: "The user has insufficient permissions"}})
    )
    |> halt()
  end

  def is_admin(%User{} = user), do: user.role.name == "Admin"

  def is_manager(%User{} = user, or_higher \\ true),
    do: user.role.name == "Manager" or (or_higher and is_admin(user))

  def is_employee(%User{} = user, or_higher \\ true),
    do: user.role.name == "Employee" or (or_higher and is_manager(user, true))

  defp get_required_permission(conn, opts) do
    action = action_name(conn)

    case opts
         |> Keyword.fetch!(:actions)
         |> Keyword.fetch(action) do
      :error -> :error
      {:ok, acts} -> acts
    end
  end
end
