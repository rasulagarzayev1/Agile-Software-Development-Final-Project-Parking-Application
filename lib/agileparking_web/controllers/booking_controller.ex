defmodule AgileparkingWeb.BookingController do
  use AgileparkingWeb, :controller
  import Ecto.Query
  alias Agileparking.Repo
  alias Agileparking.Bookings.Booking

  def index(conn, _params) do
    user = Agileparking.Authentication.load_current_user(conn)
    bookings = Repo.all(from b in Booking, where: b.user_id == ^user.id)
    render conn, "index.html", bookings: bookings
  end

end
