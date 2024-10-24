defmodule TimeManager.Roles.Default do
  def base_permissions() do
    %{
      "me" => ["read", "update", "delete", "clock"],
      "user" => ["read"],
      "role" => ["read"],
      "team" => ["read"]
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
          Map.put(base_permissions(),
            user: ["clock"],
            team: ["create", "read", "update", "delete", "clock"],
            clock: ["read"]
          )
      },
      %{
        name: "Employee",
        permissions: Map.put(base_permissions())
      }
    ]
  end
end
