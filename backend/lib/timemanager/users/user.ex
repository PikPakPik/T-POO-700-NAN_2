defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    has_many :working_times, TimeManager.WorkingTimes.WorkingTime
    has_one :clocks, TimeManager.Clocks.Clock

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/, message: "this is not a valid email")
  end
end
