defmodule Agileparking.Repo.Migrations.AddEmailAndLicenseNumber do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :license_number, :string
      remove :username
    end
  end
end
