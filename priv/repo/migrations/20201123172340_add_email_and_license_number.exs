defmodule Agileparking.Repo.Migrations.AddEmailAndLicenseNumber do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :license_number, :string
      remove :username
    end

    create unique_index(:users, [:email])
  end
end
