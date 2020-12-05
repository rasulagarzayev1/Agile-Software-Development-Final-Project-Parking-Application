defmodule Agileparking.Repo.Migrations.UpdateZones do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      add :vacant, :integer
    end

  end
end
