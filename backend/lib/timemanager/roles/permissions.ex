defmodule TimeManager.Roles.Permissions do
  import Ecto.Changeset

  def all() do
    %{
      "me" => ["read", "update", "delete", "clock"],
      "user" => ["create", "read", "update", "delete", "clock", "role"],
      "team" => ["create", "read", "update", "delete", "clock"],
      "clock" => ["read", "delete"],
      "working_time" => ["create", "read", "update", "delete"],
      "role" => ["read"],
      "log" => ["read"]
    }
  end

  def validate_permissions(changeset, field) do
    validate_change(changeset, field, fn _field, permissions ->
      permissions
      |> Map.merge(all(), fn _key, perms1, perms2 ->
        Enum.uniq(perms1 ++ perms2)
      end)
      |> case do
        %{} -> %{}
        invalid_permissions -> [{field, {"invalid permissions", invalid_permissions}}]
      end
    end)
  end

  def has_permission?(permissions, required_perms) do
    Enum.all?(required_perms, fn {key, perms} ->
      Enum.all?(perms, fn perm ->
        Enum.member?(Map.get(permissions, key, []), perm)
      end)
    end)
  end

  def user_has_permission?(user, permission) do
    has_permission?(user.role.permissions, permission)
  end
end
