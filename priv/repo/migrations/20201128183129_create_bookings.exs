defmodule Agileparking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :payment_status, :string
      add :start_date, :string
      add :end_date, :string
      add :zone_type, :string

      timestamps()
    end

  end
end
