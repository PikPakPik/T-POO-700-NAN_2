defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user, %{associations: true}))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user, %{associations: true, except: [:password_hash]})}
  end

  defp data(%User{} = user, options \\ %{}) do
    TimeManagerWeb.ModelToJson.serialize_data(user, options)
  end
end
