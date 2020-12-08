defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration
  #requirement 1.1
  suite name:          "Register",
         context:       UserManagementContext,
         feature_paths: ["features/user_registration.feature"]

  #requirement 1.2
  suite name:          "Login",
        context:       UserManagementContext,
        feature_paths: ["features/user_login.feature"]

  #requirement 1.3
  suite name:          "Logout",
        context:       UserManagementContext,
        feature_paths: ["features/user_logout.feature"]

  #requirement 2.1 and 2.2
  suite name:          "Search parking",
         context:       SearchParkingContext,
         feature_paths: ["features/zone_search_parking.feature"]

  #requirement 2.3 and 2.4
  suite name:          "Search parking with time",
        context:       SearchParkingContext,
         feature_paths: ["features/zone_search_with_time.feature"]

  #from previous spirints
  # suite name:          "Add balance",
  #       context:       AddBalanceContext,
  #       feature_paths: ["features/user_adding_balance.feature"]

  # suite name:          "Add card",
  #       context:       AddCardContext,
  #       feature_paths: ["features/user_adding_card.feature"]

  #requirement 3.1
  suite name:          "Booking context",
          context:       BookingContext,
          feature_paths: ["features/booking_select_hourly_real_time.feature"]

  #requirement 3.2
  suite name:          "Submit a start and end of parking time ",
          context:       BookingContext,
          feature_paths: ["features/booking_submit_time.feature"]

  #requirement 3.5
  suite name:          "Extend Booking context",
        context:       BookingContext,
        feature_paths: ["features/extend_booking.feature"]

  #requirement 4.1
  suite name:          "Pay before starting the parking period",
        context:       BookingContext,
        feature_paths: ["features/booking_pay_before.feature"]

  #requirement 4.2
   suite name:          "Pay after extending the parking period",
         context:       BookingContext,
         feature_paths: ["features/booking_pay_after_extending.feature"]

    #requirement 4.3
    suite name:          "Booking pay at the end of the parking period",
           context:       BookingContext,
           feature_paths: ["features/booking_pay_end.feature"]
           
    #requirement 4.4
    suite name:          "Booking pay at the end of the month",
          context:        BookingContext,
          feature_paths: ["features/booking_pay_end_of_month.feature"]
end
