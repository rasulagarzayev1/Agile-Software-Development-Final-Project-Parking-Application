defmodule Agileparking.Accounts.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :cvc, :string
    field :month, :string
    field :name, :string
    field :number, :string
    field :year, :string
    belongs_to :user, Agileparking.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :number, :month, :year, :cvc])
    |> validate_required([:name, :number, :month, :year, :cvc])
    |> validate_length(:name, min: 3)
    |> validate_length(:cvc, min: 3)
    |> validate_length(:number, min: 16)
    |> validate_number(:month, greater_than: 0, less_than: 13)
    |> validate_number(:year, greater_than: 2020)
  end
end
