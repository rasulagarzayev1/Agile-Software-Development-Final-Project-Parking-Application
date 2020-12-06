defmodule Agileparking.Repo.Migrations.UpdateBookingTable do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :zoneId, :string
      add :totalPrice, :string
      add :paymentType, :string
      add :parkingStatus, :string
      remove :zone_type
    end
  end
end
