defmodule Agileparking.Repo.Migrations.CreateZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string
      add :hourlyPrice, :integer
      add :realTimePrice, :integer
      timestamps()
    end

  end
end
