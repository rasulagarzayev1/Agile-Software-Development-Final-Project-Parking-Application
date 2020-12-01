defmodule Agileparking.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :end_date, :string
    field :payment_status, :string
    field :start_date, :string
    field :zone_type, :string

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:payment_status, :start_date, :end_date, :zone_type])
    |> validate_required([:payment_status, :start_date, :end_date, :zone_type])
  end
end