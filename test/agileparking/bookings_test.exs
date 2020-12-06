# defmodule Agileparking.BookingsTest do
#   use Agileparking.DataCase

#   alias Agileparking.Bookings

#   describe "bookings" do
#     alias Agileparking.Bookings.Booking

#     @valid_attrs %{end_date: "some end_date", payment_status: "some payment_status", start_date: "some start_date", zone_type: "some zone_type"}
#     @update_attrs %{end_date: "some updated end_date", payment_status: "some updated payment_status", start_date: "some updated start_date", zone_type: "some updated zone_type"}
#     @invalid_attrs %{end_date: nil, payment_status: nil, start_date: nil, zone_type: nil}

#     def booking_fixture(attrs \\ %{}) do
#       {:ok, booking} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Bookings.create_booking()

#       booking
#     end

#     test "list_bookings/0 returns all bookings" do
#       booking = booking_fixture()
#       assert Bookings.list_bookings() == [booking]
#     end

#     test "get_booking!/1 returns the booking with given id" do
#       booking = booking_fixture()
#       assert Bookings.get_booking!(booking.id) == booking
#     end

#     test "create_booking/1 with valid data creates a booking" do
#       assert {:ok, %Booking{} = booking} = Bookings.create_booking(@valid_attrs)
#       assert booking.end_date == "some end_date"
#       assert booking.payment_status == "some payment_status"
#       assert booking.start_date == "some start_date"
#       assert booking.zone_type == "some zone_type"
#     end

#     test "create_booking/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Bookings.create_booking(@invalid_attrs)
#     end

#     test "update_booking/2 with valid data updates the booking" do
#       booking = booking_fixture()
#       assert {:ok, %Booking{} = booking} = Bookings.update_booking(booking, @update_attrs)
#       assert booking.end_date == "some updated end_date"
#       assert booking.payment_status == "some updated payment_status"
#       assert booking.start_date == "some updated start_date"
#       assert booking.zone_type == "some updated zone_type"
#     end

#     test "update_booking/2 with invalid data returns error changeset" do
#       booking = booking_fixture()
#       assert {:error, %Ecto.Changeset{}} = Bookings.update_booking(booking, @invalid_attrs)
#       assert booking == Bookings.get_booking!(booking.id)
#     end

#     test "delete_booking/1 deletes the booking" do
#       booking = booking_fixture()
#       assert {:ok, %Booking{}} = Bookings.delete_booking(booking)
#       assert_raise Ecto.NoResultsError, fn -> Bookings.get_booking!(booking.id) end
#     end

#     test "change_booking/1 returns a booking changeset" do
#       booking = booking_fixture()
#       assert %Ecto.Changeset{} = Bookings.change_booking(booking)
#     end
#   end
# end
