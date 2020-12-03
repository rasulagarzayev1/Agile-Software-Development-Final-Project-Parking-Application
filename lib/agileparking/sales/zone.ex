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

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:name, :hourlyPrice, :realTimePrice, :vacant])
    |> validate_required([:name, :hourlyPrice, :realTimePrice])
  end
end
