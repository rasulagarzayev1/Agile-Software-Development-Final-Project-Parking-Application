defmodule Agileparking.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :number, :string
      add :month, :string
      add :year, :string
      add :cvc, :string

      timestamps()
    end

  end
end
