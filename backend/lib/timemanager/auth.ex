defmodule TimeManager.Auth do
  use Joken.Config
  require Logger

  alias TimeManager.Users
  alias TimeManager.Repo

  @impl true
  def token_config do
    default_claims()
    |> add_claim("exp", fn ->
      DateTime.utc_now() |> DateTime.add(30 * 24 * 60 * 60, :second) |> DateTime.to_unix()
    end)
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Users.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def generate_jwt(user) do
    xsrf_token = UUID.uuid4()

    claims = %{
      "sub" => user.id,
      "role" => user.role,
      "xsrf_token" => xsrf_token
    }

    {:ok, jwt, _claims} = TimeManager.Auth.generate_and_sign(claims)
    {jwt, xsrf_token}
  end

  def verify_jwt(jwt, xsrf_token) do
    case TimeManager.Auth.verify_and_validate(jwt) do
      {:ok, claims} ->
        if claims["xsrf_token"] == xsrf_token do
          {:ok, claims}
        else
          {:error, :invalid_xsrf_token}
        end

      {:error, reason} ->
        Logger.error("JWT Verification Error: #{inspect(reason)}")
        {:error, reason}
    end
  rescue
    exception ->
      Logger.error("Exception occurred: #{inspect(exception)}")
      {:error, :internal_server_error}
  end

  def get_user(conn) do
    xsrf_token =
      case List.keyfind(conn.req_headers, "c-xsrf-token", 0) do
        nil -> nil
        {_, token} -> token
      end

    result = TimeManager.Auth.verify_jwt(conn.cookies["jwt"], xsrf_token)

    case result do
      {:ok, claims} ->
        user = Users.get_user!(claims["sub"]) |> Repo.preload(:role)
        user

      {:error, _} ->
        nil
    end
  end

  def get_user_id(conn) do
    case get_user(conn) do
      nil -> nil
      user -> user.id
    end
  end
end
