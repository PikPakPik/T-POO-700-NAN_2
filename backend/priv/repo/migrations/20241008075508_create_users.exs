defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:email, :string)
      add(:password, :string)
      add(:role_id, references(:roles))
      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:email]))
    create(index(:users, [:role_id]))
  end
end
