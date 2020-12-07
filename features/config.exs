defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration

#   suite name:          "Register",
#         context:       UserManagementContext,
#         feature_paths: ["features/user_registration.feature"]

#   suite name:          "Login",
#         context:       UserManagementContext,
#         feature_paths: ["features/user_login.feature"]

  #  suite name:          "Search parking",
  #        context:       SearchParkingContext,
  #        feature_paths: ["features/zone_search_parking.feature"]

  suite name:          "Search parking with time",
        context:       SearchParkingContext,
         feature_paths: ["features/zone_search_with_time.feature"]

#   suite name:          "Add balance",
#         context:       AddBalanceContext,
#         feature_paths: ["features/user_adding_balance.feature"]

#   suite name:          "Add card",
#         context:       AddCardContext,
# #         feature_paths: ["features/user_adding_card.feature"]

#    suite name:          "Booking context",
#          context:       BookingContext,
#           feature_paths: ["features/booking_select_hourly_real_time.feature"]

#   suite name:          "Extend Booking context",
#         context:       BookingContext,
#         feature_paths: ["features/extend_booking.feature"]

#   suite name:          "Submit a start and end of parking time ",
#         context:       BookingContext,
#         feature_paths: ["features/booking_submit_time.feature"]

#   suite name:          "Pay before starting the parking period",
#         context:       BookingContext,
#         feature_paths: ["features/booking_pay_before.feature"]

#    suite name:          "Pay after extending the parking period",
#          context:       BookingContext,
#          feature_paths: ["features/booking_pay_after_extending.feature"]

    suite name:          "Booking pay at the end of the parking period",
           context:       BookingContext,
           feature_paths: ["features/booking_pay_end.feature"]
end
