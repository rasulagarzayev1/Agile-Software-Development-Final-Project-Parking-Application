defmodule Agileparking.Sales.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :hourlyPrice, :integer
    field :realTimePrice, :integer
    field :vacant, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :hourlyPrice, :realTimePrice, :vacant])
    |> validate_required([:name, :hourlyPrice, :realTimePrice])
  end
end
