defmodule Agileparking.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :end_date, :string, default: "-"
    field :payment_status, :string, default: "Pending"
    field :start_date, :string
    field :totalPrice, :string, default: "0"
    field :paymentType, :string, default: "-"
    field :parkingStatus, :string, default: "Started"
    field :zoneId, :string
    belongs_to :user, Agileparking.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:payment_status, :start_date, :end_date])
    |> validate_required([:payment_status, :start_date, :end_date])
  end
end
