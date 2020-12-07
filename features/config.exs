defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration

  suite name:          "Register",
        context:       UserManagementContext,
        feature_paths: ["features/user_registration.feature"]

   suite name:          "Login",
         context:       UserManagementContext,
         feature_paths: ["features/user_login.feature"]

   suite name:          "Logout",
         context:       UserManagementContext,
         feature_paths: ["features/user_logout.feature"]


    suite name:          "Search parking",
          context:       SearchParkingContext,
          feature_paths: ["features/zone_search_parking.feature"]

    suite name:          "Search parking with time",
          context:       SearchParkingContext,
          feature_paths: ["features/zone_search_with_time.feature"]


#   suite name:          "Add balance",
#         context:       AddBalanceContext,
#         feature_paths: ["features/user_adding_balance.feature"]

#   suite name:          "Add card",
#         context:       AddCardContext,
#         feature_paths: ["features/user_adding_card.feature"]
         context:       BookigWithHourlyRealTimeContext,
          feature_paths: ["features/bookig_with_hourly_real_time_payment.feature"]
end
