defmodule TimeManager.Roles.Default do
  def all() do
    [
      %{
        name: "Admin",
      },
      %{
        name: "Manager",
      },
      %{
        name: "Employee",
      }
    ]
  end
end
