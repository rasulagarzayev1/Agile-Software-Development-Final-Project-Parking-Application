# defmodule AgileparkingWeb.SessionsControllerTest do
#   use AgileparkingWeb.ConnCase
#   alias Agileparking.Repo
#   alias Agileparking.Accounts.User

#   test "Test login success", %{conn: conn} do
#     conn = post conn, "/users", %{user: [name: "Farid1", email: "farid1@gmail.com", license_number: "123456789", password: "1234567" ]}


#     conn = post conn, "/sessions", %{session: [email: "farid1@gmail.com", password: "1234567" ]}
#     conn = get conn, redirected_to(conn)

#     assert conn.resp_body =~ ~r/Welcome/
#   end

#   test "Test login failure", %{conn: conn} do

#     conn = post conn, "/sessions", %{session: [email: "farid", password: "1234567" ]}
#     assert conn.resp_body =~ ~r/Bad User Credentials/
#   end
# end
