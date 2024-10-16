defmodule TimeManager.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :action, :string
    field :time, :utc_datetime
    field :new_value, :map
    field :old_value, :map
    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :user_id, :time, :new_value, :old_value])
    |> validate_required([:action, :user_id, :time, :new_value, :old_value])
  end
end
