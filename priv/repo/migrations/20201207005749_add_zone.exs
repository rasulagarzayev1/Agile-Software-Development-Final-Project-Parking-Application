defmodule Agileparking.Repo.Migrations.AddZone do
  use Ecto.Migration

  def change do
    alter table(:zones) do
      add :zone, :string
  end
end
end