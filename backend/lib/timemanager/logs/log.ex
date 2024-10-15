defmodule TimeManager.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :action, :string
    field :time, :utc_datetime
    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :user_id, :time])
    |> validate_required([:action, :user_id, :time])
  end
end
