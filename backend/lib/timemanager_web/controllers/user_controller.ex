defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManager.Roles
  alias TimeManagerWeb.SwaggerDef

  action_fallback(TimeManagerWeb.FallbackController)

  def swagger_definitions do
    SwaggerDef.user_definitions()
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{token: token})

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  swagger_path(:index) do
    summary("List Users")
    description("List all users in the database.")

    parameters do
      email(:query, :string, "Email")
      username(:query, :string, "Username")
    end

    response(200, "OK", Schema.ref(:UsersResponse))
  end

  def index(conn, params) do
    case users = Users.list_users(params) do
      [] -> {:error, :not_found}
      user -> render(conn, :index, users: users)
    end
  end

  swagger_path(:create) do
    summary("Create User")
    description("Create a new user.")

    parameters do
      user(:body, Schema.ref(:UserRequest), "The user details")
    end

    response(201, "Created Successfully", Schema.ref(:UserResponse))
    response(422, "Unprocessable Entity", Schema.ref(:UnprocessableEntityResponse))
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  swagger_path(:show) do
    summary("Show User")
    description("Show an user by his ID")
    parameter(:id, :path, :integer, "User ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path(:update) do
    summary("Update user")
    description("Update attributes of a user")

    parameters do
      id(:path, :integer, "User ID", required: true, example: 3)
      user(:body, Schema.ref(:UserRequest), "The user details (can be partial)")
    end

    response(200, "Updated Successfully", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
    response(422, "Unprocessable Entity", Schema.ref(:UnprocessableEntityResponse))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path(:delete) do
    summary("Delete user")
    description("Delete a user by ID")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)

    response(204, "No Content")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path(:set_role) do
    summary("Modify user role")
    description("Modify a user role.")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 3)
    parameter(:roleID, :path, :integer, "Role ID", required: true, example: 3)

    response(200, "OK")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end

  def set_role(conn, %{"userID" => user_id, "roleID" => role_id}) do
    user = TimeManager.Repo.preload(Users.get_user!(user_id), :role)
    role = TimeManager.Roles.get_role!(role_id)

    with {:ok, %User{} = user} <- Users.update_user_role(user, role) do
      render(conn, :show, user: user)
    end
  end
end
