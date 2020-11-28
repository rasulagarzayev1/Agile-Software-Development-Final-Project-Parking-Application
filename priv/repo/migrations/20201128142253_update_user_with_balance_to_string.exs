defmodule Agileparking.Repo.Migrations.UpdateUserWithBalanceToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :balance
      add :balance, :string
    end
  end
end
