# TimeManager

### Production:  
https://timemanager-front.atressel.fr (Frontend)  
https://timemanager-back.atressel.fr (API)

###### _If you have ERR_SSL_VERSION_OR_CIPHER_MISMATCH, please use this url instead:_
https://time-manager-front-nan-2-main.onrender.com  
https://time-manager-api-nan-2-main.onrender.com

## Prerequisites for local development

Before launching the TimeManager platform, ensure you have the following installed:

1. Elixir (version 1.14 or later)
2. Erlang (version 24 or later)
3. Phoenix Framework (version 1.7 or later)
4. PostgreSQL (version 14 or later)

## Start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## Creating and Migrating Database Schemas

1. Create database, run `mix ecto.create`

2. Migrate database, run `mix ecto.migrate`

3. Populate database with data, run `mix run priv/repo/seeds.exs`

## Testing Routes with Postman OR Swagger

1. Download and install Postman Agent.

2. Import the TimeManager API collection, the collection includes pre-configured requests for Users, Clocks, and Working Times endpoints (Routes.postman_collection.json).

3. Ensure your Phoenix server is running locally before testing.

(If you want to use Swagger)
_Go to http://localhost:4000/api/swagger_

4. Execute requests to test the API functionality.

## Prerequisites for Docker

1. Docker
2. Docker Compose

## Launching the platform with Docker

Multiple profiles are available:

- `-backend`: only backend
- `-frontend`: only frontend
- `-all`: backend and frontend

Run `./timemanager.sh -all` to launch the platform with Docker.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


