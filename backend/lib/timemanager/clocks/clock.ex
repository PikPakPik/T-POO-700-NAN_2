defmodule TimeManager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :status, :time, :user_id, :inserted_at, :updated_at]}
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> Ecto.Changeset.cast(attrs, [:time, :status, :user_id])
    |> Ecto.Changeset.validate_required([:time, :status, :user_id])
  end
end
