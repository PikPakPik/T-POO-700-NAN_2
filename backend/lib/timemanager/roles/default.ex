defmodule TimeManager.Roles.Default do
  defp base_permissions() do
    %{
      "me" => ["read", "update", "delete", "clock"],
      "user" => ["read"],
      "role" => ["read"]
    }
  end

  def all() do
    [
      %{
        name: "Admin",
        permissions: TimeManager.Roles.Permissions.all()
      },
      %{
        name: "Manager",
        permissions:
          Map.put(base_permissions(), "team", ["create", "read", "update", "delete", "clock"])
      },
      %{
        name: "Employee",
        permissions: Map.put(base_permissions(), "team", ["read"])
      }
    ]
  end
end
