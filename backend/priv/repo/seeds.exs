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

# Liste user
users_data = [
    %{"username" => "Gerard Martin", "email" => "gerard.martin@example.com"},
    %{"username" => "Lucie Boucher", "email" => "lucie.boucher@example.com"},
    %{"username" => "Emilie Durand", "email" => "emilie.durand@example.com"},
    %{"username" => "Thomas Roux", "email" => "thomas.roux@example.com"},
    %{"username" => "Pauline Lemoine", "email" => "pauline.lemoine@example.com"},
    %{"username" => "Arthur Dupuis", "email" => "arthur.dupuis@example.com"},
    %{"username" => "Sophie Bernard", "email" => "sophie.bernard@example.com"},
    %{"username" => "Nicolas Morel", "email" => "nicolas.morel@example.com"},
    %{"username" => "Caroline David", "email" => "caroline.david@example.com"},
    %{"username" => "Julien Petit", "email" => "julien.petit@example.com"}
]

# Create user, clock, workingtime
for user_data <- users_data do
  user = Repo.insert!(%User{
    username: user_data["username"],
    email: user_data["email"]
  })

  # format date utc_datetime
  clock_in_time = NaiveDateTime.new!(2024, 10, 8, 9, 0, 0) |> DateTime.from_naive!("Etc/UTC")
  clock_out_time = NaiveDateTime.new!(2024, 10, 8, 17, 0, 0) |> DateTime.from_naive!("Etc/UTC")

  Repo.insert!(%Clock{
    time: clock_in_time,
    status: true,
    user_id: user.id
  })

  Repo.insert!(%Clock{
    time: clock_out_time,
    status: false,
    user_id: user.id
  })

  Repo.insert!(%WorkingTime{
    start: clock_in_time,
    end: clock_out_time,
    user_id: user.id
  })
end

