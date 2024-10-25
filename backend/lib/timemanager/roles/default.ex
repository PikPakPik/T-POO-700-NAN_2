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
          base_permissions()
          |> Map.put("user", ["clock"])
          |> Map.put("team", ["create", "read", "update", "delete", "clock"])
          |> Map.put("clock", ["read"])
          |> Map.put("working_time", ["create", "read", "update", "delete"])
      },
      %{
        name: "Employee",
        permissions: base_permissions()
      }
    ]
  end
end
