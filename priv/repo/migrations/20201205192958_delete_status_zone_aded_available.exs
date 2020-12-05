defmodule Agileparking.Repo.Migrations.DeleteStatusZoneAdedAvailable do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      remove :status
      add :available, :boolean
    end
  end
end
