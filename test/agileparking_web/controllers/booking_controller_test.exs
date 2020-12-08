
defmodule AgileparkingWeb.BookingControllerTest do
  use AgileparkingWeb.ConnCase

  alias Agileparking.{Repo, Sales.Zone}
  alias Agileparking.Guardian
  alias Agileparking.Accounts.User
  alias Agileparking.Bookings.Booking
  import Ecto.Query, only: [from: 2]

  @create_attrs %{id: 1, name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678", balance: "12.43", monthly_bill: "4.28"}

  setup do
    user = Repo.insert!(%User{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678", balance: "12.43", monthly_bill: "4.28"})
    conn = build_conn()
           |> bypass_through(Agileparking.Router, [:browser, :browser_auth, :ensure_auth])
           |> get("/")
           |> Map.update!(:state, fn (_) -> :set end)
           |> Guardian.Plug.sign_in(user)
           |> send_resp(200, "Flush the session")
           |> recycle
    {:ok, conn: conn}
  end

  # Requirements 3.1
  test "Check database", %{conn: conn} do
    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    # ADD BOOKING
    conn = put conn, "/zones/1", %{id: 1, zone: [id: 1, end_date: "14:00", hourlyPrice: "2", pay_now: "true", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    # CHECKING DATABASE BY CHECKING BOOKING
    booking =  Repo.get!(Booking, 1)
    payment = booking.paymentType
    # CHECKING DATABASE BY CHECKING BOOKING IN BOOKINGS INDEX PAGE
    assert html_response(conn, 200) =~ "#{payment}"
  end

  # Requirements 3.2
  test "Invalid times/dates ", %{conn: conn} do
    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    # END IS BEFORE THE START TIME
    conn = put conn, "/zones/1", %{id: 1, zone: [end_date: "10:00", hourlyPrice: "2", pay_now: "true", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/The start always should occur before the end time/
  end

  # Requirements 3.3
  test "Blocks the corresponding parking space", %{conn: conn} do
    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    # FIRST BOOKING IS ADDED AND SLOT AVAILABILITY UPDATED
    conn = put conn, "/zones/1", %{id: 1, zone: [end_date: "13:00", hourlyPrice: "2", pay_now: "true", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)

    # SECOND BOOKING IS TRIED TO ADD BUT UNSUCCESSFUL BECAUSE THE SLOT IS NOT AVAILABLE
    conn = put conn, "/zones/1", %{id: 1, zone: [end_date: "13:00", hourlyPrice: "2", pay_now: "true", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/There is no an available slot. Please choose new parking area/
  end

  # Requirements 3.5
  test "Extend parking period", %{conn: conn} do
    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn = put conn, "/zones/1", %{id: 1, zone: [id: 1, end_date: "13:30", hourlyPrice: "2", pay_now: "false", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    booking =  Repo.get!(Booking, 1)

    conn = put conn, "/bookings/1", %{id: 1, booking: [id: 1, end_date: "11:30"]}
    conn = get conn, redirected_to(conn)

    assert html_response(conn, 200) =~ ~r/End date should be greater than start date/
  end

  # Requirement 4.1
  test "Pay before starting the parking period", %{conn: conn} do

    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn = put conn, "/zones/1", %{id: 1, zone: [end_date: "13:30", hourlyPrice: "2", pay_now: "true", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    balance = "12.43"
    user = Agileparking.Authentication.load_current_user(conn)
    {old_balance, _ } = Float.parse(balance)
    {new_balance, _ } = Float.parse(user.balance)
    price = totalPriceHourly("12:00", "13:30", 2)

    assert old_balance - price == new_balance
  end

  # Requirement 4.2
  test "Pay after extending the parking period", %{conn: conn} do

    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn = put conn, "/zones/1", %{id: 1, zone: [id: 1, end_date: "13:30", hourlyPrice: "2", pay_now: "false", payment_type: "Hourly", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)
    conn = put conn, "/bookings/1", %{id: 1, booking: [id: 1, end_date: "14:30"]}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)

    {old_balance, _ } = Float.parse(user.balance)

    conn = delete conn, "/bookings/1", %{id: 1, booking: [id: 1, end_date: "14:30"]}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)
    {new_balance, _ } = Float.parse(user.balance)

    price = totalPriceHourly("12:00", "14:30", 2)

    #  assert html_response(conn, 200) =~ ~r/8.43/
    assert old_balance - price == new_balance
  end

   # Requirement 4.3
   test "Pay at the end", %{conn: conn} do

    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn = put conn, "/zones/1", %{id: 1, zone: [id: 1, end_date: "12:37", hourlyPrice: "2", pay_now: "false", payment_type: "Real", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)

    {old_balance, _ } = Float.parse(user.balance)

    conn = delete conn, "/bookings/1", %{id: 1}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)
    {new_balance, _ } = Float.parse(user.balance)

    price = totalPriceReal("12:00", "12:37", 16)
    assert old_balance - price == new_balance
  end

  # Requirement 4.4
  test "Pay at the end of the month", %{conn: conn} do

    Repo.insert!(%Zone{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn = put conn, "/zones/1", %{id: 1, zone: [id: 1, end_date: "12:37", hourlyPrice: "2", pay_now: "false", payment_type: "Real", realTimePrice: "16", start_date: "12:00", total_payment: "2"]}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)

    {old_balance, _ } = Float.parse(user.balance)
    {old_monthly_bill, _ } = Float.parse(user.monthly_bill)

    conn = get conn, "/bookings/paylater/1", %{id: 1}
    conn = get conn, redirected_to(conn)

    user = Agileparking.Authentication.load_current_user(conn)
    bill = String.slice(user.monthly_bill, 0..5)
    {new_balance, _ } = Float.parse(user.balance)
    {new_monthly_bill, _ } = Float.parse(bill)

    price = totalPriceReal("12:00", "12:37", 16)
    bill_difference = Float.ceil(sub(new_monthly_bill, old_monthly_bill), 2 )
    assert old_balance - new_balance == 0 and bill_difference == price
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
