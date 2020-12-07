defmodule Agileparking.Repo.Migrations.AddedMonthlyBill do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :monthly_bill, :string
    end

  end
end
