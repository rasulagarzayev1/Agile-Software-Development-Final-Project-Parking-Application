defmodule Agileparking.Repo.Migrations.UpdateUserWithBalance do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal
    end
  end
end
