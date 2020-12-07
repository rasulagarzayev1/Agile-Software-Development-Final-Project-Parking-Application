defmodule Agileparking.Sales.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :hourlyPrice, :integer
    field :realTimePrice, :integer
    field :available, :boolean
    field :zone, :string
    timestamps()
  end

  @doc false
  def changeset(zone, attrs) do
    zone
    |> cast(attrs, [:name, :hourlyPrice, :realTimePrice, :available, :zone])
    |> validate_required([:name, :hourlyPrice, :realTimePrice, :available, :zone])
  end
end
