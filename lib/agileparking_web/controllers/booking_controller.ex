defmodule AgileparkingWeb.BookingController do
  use AgileparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Ecto.{Changeset, Multi}
  alias Agileparking.Repo
  alias Agileparking.Bookings
  alias Agileparking.Bookings.Booking
  alias Agileparking.Sales.Zone
  alias Agileparking.Accounts.User


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
    user = Agileparking.Authentication.load_current_user(conn)
    booking=Bookings.get_booking!(id)




    zones=Repo.get_by(Zone,id: booking.zoneId)

    case booking.payment_status=="Pending" do
      true->
        {current_balance,_}=Float.parse(user.balance)
        {totalPrice,_}=Float.parse(booking.totalPrice)

        case sub(current_balance,totalPrice)>0 do
          true->
            Repo.get_by(User,id: user.id)
            |> Ecto.Changeset.change(%{balance: Float.to_string(sub(current_balance,totalPrice))})
            |>Repo.update()
            Repo.get_by(Zone,id: booking.zoneId)
             |> Ecto.Changeset.change(%{available: true})
             |>Repo.update()
            _ -> conn
            |> put_flash(:error, "There is not enough balance. Please increase balance")
            |> redirect(to: Routes.booking_path(conn, :index))
        end
    end
    {:ok, _booking} = Repo.get_by(Booking,id: booking.id)
                              |>Ecto.Changeset.change(%{parkingStatus: "Finished"})
                              |>Repo.update()

    conn
    |> put_flash(:info,"Booking finished succesfully")
    |> redirect(to: Routes.booking_path(conn,:index))

  end

  def sub(a, b), do: a - b





end
