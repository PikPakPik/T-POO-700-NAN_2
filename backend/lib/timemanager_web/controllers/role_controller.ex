defmodule TimeManagerWeb.RoleController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Roles
  alias TimeManager.Roles.Role
  alias TimeManagerWeb.SwaggerDef
  alias TimeManagerWeb.Plugs.PermissionPlug
  action_fallback(TimeManagerWeb.FallbackController)

  def swagger_definitions do
    SwaggerDef.role_definitions()
  end

  plug(PermissionPlug,
    actions: [
      index: %{"role" => ["read"]},
      show: %{"role" => ["read"]}
    ]
  )

  swagger_path(:index) do
    summary("List Roles")
    description("List all roles in the database.")

    SwaggerDef.api_protected_path()

    response(200, "OK", Schema.ref(:RolesResponse))
  end

  def index(conn, _params) do
    roles = Roles.list_roles()
    render(conn, :index, roles: roles)
  end

  swagger_path(:show) do
    summary("Show role")
    description("Show a role by ID.")

    SwaggerDef.api_protected_path()

    parameter(:id, :path, :integer, "Role ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:RoleResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, :show, role: role)
  end
end
