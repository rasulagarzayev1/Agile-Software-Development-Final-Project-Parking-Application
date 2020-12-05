defmodule Agileparking.Repo.Migrations.AddedStatusZone do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      add :status, :boolean
  end
end
end