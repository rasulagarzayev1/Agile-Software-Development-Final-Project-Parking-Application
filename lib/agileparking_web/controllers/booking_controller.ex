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

  def edit(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)
    changeset = Booking.changeset(booking, %{})

    render(conn, "edit.html", booking: booking, changeset: changeset)
  end

  def update(conn,%{"id" => id, "booking" => booking_params}) do

    booking=Repo.get_by(Booking,id: id)

    zones=Repo.get_by(Zone,id: booking.zoneId)

    total=totalPriceHourly(booking.start_date,booking_params["end_date"],zones.hourlyPrice)

    if totalTime(booking.start_date,booking_params["end_date"])<0 do
      conn
      |>put_flash(:error, "End date should be greater than start date")
      |> redirect(to: Routes.booking_path(conn, :index))
    end

    Repo.get_by(Booking,id: id)
     |>Ecto.Changeset.change(%{end_date: booking_params["end_date"],totalPrice: Float.to_string(total) })
    |>Repo.update()

    conn
    |> put_flash(:info, "Succesfully updated")
    |>redirect(to: Routes.booking_path(conn,:index))

  end

  def delete(conn,%{"id"=>id}) do
    user = Agileparking.Authentication.load_current_user(conn)
    booking=Bookings.get_booking!(id)



    Repo.get_by(Zone,id: booking.zoneId)
             |> Ecto.Changeset.change(%{available: true})
             |>Repo.update()

    if booking.payment_status=="Pending" do
        case booking.end_date !="-" do
          true->
            {current_balance,_}=Float.parse(user.balance)
            {totalPrice,_}=Float.parse(booking.totalPrice)
            case sub(current_balance,totalPrice)>0 do
              true->
                Repo.get_by(User,id: user.id)
                  |> Ecto.Changeset.change(%{balance: Float.to_string(sub(current_balance,totalPrice))})
                  |>Repo.update()
              _ -> conn
              |> put_flash(:error, "There is not enough balance. Please increase balance")
              |> redirect(to: Routes.booking_path(conn, :index))
            end
           _ -> conn
             |> put_flash(:error,"Please enter the end date for calculation")
             |> redirect(to: Routes.booking_path(conn,:edit,booking))
        end
    end
    {:ok, _booking} = Repo.get_by(Booking,id: booking.id)
                              |>Ecto.Changeset.change(%{parkingStatus: "Finished"})
                              |>Repo.update()

    conn
    |> put_flash(:info,"Booking finished succesfully")
    |> redirect(to: Routes.booking_path(conn,:index))

  end
      def product(a, b), do: a * b
      def sum(a, b), do: a + b
      def sub(a, b), do: a - b
      def divi(a, b), do: a / b
      def totalTime(start_date, end_date) do
        {startHour, _} = Integer.parse(String.slice(start_date, 0..1))
        {startMin, _} = Integer.parse(String.slice(start_date, 3..4))
        startTotalMin = sum(product(startHour, 60),startMin)

        {endHour, _} = Integer.parse(String.slice(end_date, 0..1))
        {endMin, _} = Integer.parse(String.slice(end_date, 3..4))
        endTotalMin = sum(product(endHour, 60),endMin)
        differenceMin = sub(endTotalMin, startTotalMin)
      end

      def totalPriceHourly(start_date, end_date, hourlyPrice) do
        time = totalTime(start_date, end_date)
        case Integer.mod(time , 60) == 0 do
          true -> totalPrice = product(divi(time, 60), hourlyPrice)
          _ -> totalPrice = product(sum(divi(sub(time, Integer.mod(time , 60)), 60),1), hourlyPrice)
        end
      end

      def totalPriceReal(start_date, end_date, realTimePrice) do
        time = totalTime(start_date, end_date)
        case Integer.mod(time , 5) == 0 do
          true -> totalPrice = product(divi(time, 5), divi(realTimePrice,100))
          _ -> totalPrice = product(sum(divi(sub(time, Integer.mod(time , 5)), 5),1), divi(realTimePrice,100))
        end

      end




end
