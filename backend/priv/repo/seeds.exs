# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Repo
alias TimeManager.Users.User
alias TimeManager.Clocks.Clock
alias TimeManager.WorkingTimes.WorkingTime
alias TimeManager.Teams.Team
alias TimeManager.Roles

# Create roles if they do not exist
for role <- Roles.Default.all() do
  unless Roles.get_role_by_name(role.name) do
    {:ok, _role} = Roles.create_role(role)
  end
end

# Create users and associated clocks and working times
users =
  Enum.map(1..20, fn _ ->
    user =
      Repo.insert!(%User{
        username: Faker.Person.name(),
        email: Faker.Internet.email(),
        role_id: Enum.random(2..3),
        password: Argon2.hash_pwd_salt("password")
      })

    # format date utc_datetime
    clock_in_time = NaiveDateTime.new!(2024, 10, 8, 9, 0, 0) |> DateTime.from_naive!("Etc/UTC")
    clock_out_time = NaiveDateTime.new!(2024, 10, 8, 17, 0, 0) |> DateTime.from_naive!("Etc/UTC")

    Repo.insert!(%Clock{
      time: clock_in_time,
      status: false,
      user_id: user.id
    })

    Repo.insert!(%WorkingTime{
      start: clock_in_time,
      end: clock_out_time,
      user_id: user.id
    })

    user
  end)

# Create admin user
admin_user =
  Repo.insert!(%User{
    username: "admin",
    email: "admin@nan2.fr",
    role_id: Roles.get_role_by_name("Admin").id,
    password: Argon2.hash_pwd_salt("admin")
  })

# Create additional users for development environment
if Mix.env() == :dev do
  manager_user =
    Repo.insert!(%User{
      username: "manager",
      email: "manager@nan2.fr",
      role_id: Roles.get_role_by_name("Manager").id,
      password: Argon2.hash_pwd_salt("manager")
    })

  employee_user =
    Repo.insert!(%User{
      username: "employee",
      email: "employee@nan2.fr",
      role_id: Roles.get_role_by_name("Employee").id,
      password: Argon2.hash_pwd_salt("employee")
    })
end

# Create teams
teams =
  Enum.map(["Day", "Night"], fn name ->
    Repo.insert!(%Team{name: name})
  end)

# Assign employees and managers to teams
TimeManager.Teams.assign_employee_to_team(1, Enum.at(users, 0).id)
TimeManager.Teams.assign_employee_to_team(2, Enum.at(users, 1).id)
TimeManager.Teams.assign_manager_to_team(1, admin_user.id)
TimeManager.Teams.assign_manager_to_team(2, admin_user.id)
