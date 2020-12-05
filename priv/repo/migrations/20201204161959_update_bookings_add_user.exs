defmodule Agileparking.Repo.Migrations.UpdateBookingsAddUser do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :user_id, references(:users)
    end
  end
end
