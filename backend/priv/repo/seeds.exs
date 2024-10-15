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
alias TimeManager.Roles.Role
for role <- TimeManager.Roles.Default.all() do
  unless TimeManager.Roles.get_role_by_name(role.name) do
    {:ok, _role} = TimeManager.Roles.create_role(role)
  end
end

 Enum.map(1..20, fn _ ->
  user = Repo.insert!(%User{
    username: Faker.Person.name(),
    email: Faker.Internet.email(),
    role_id: Enum.random(1..3)
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
end)
