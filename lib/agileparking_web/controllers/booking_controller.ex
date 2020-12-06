defmodule AgileparkingWeb.BookingController do
  use AgileparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Ecto.{Changeset, Multi}
  alias Agileparking.Repo
  alias Agileparking.Bookings
  alias Agileparking.Bookings.Booking
  alias Agileparking.Sales.Zone

  def index(conn, _params) do
    user = Agileparking.Authentication.load_current_user(conn)
    bookings = Repo.all(from b in Booking, where: b.user_id == ^user.id)
    render conn, "index.html", bookings: bookings
  end

  def show(conn,%{"id"=>id}) do
    booking=Bookings.get_booking!(id)

    render(conn,"show.html",booking: booking)
  end

  def delete(conn,%{"id"=>id}) do
    booking=Bookings.get_booking!(id)


    Repo.get_by(Zone,available: false)
             |> Ecto.Changeset.change(%{available: true})
             |>Repo.update()

    {:ok, _booking} = Bookings.delete_booking(booking)
    conn
    |> put_flash(:info,"Booking deleted succesfully")
    |> redirect(to: Routes.booking_path(conn,:index))
  end





end
