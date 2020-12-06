# defmodule AgileparkingWeb.CardControllerTest do
#   use AgileparkingWeb.ConnCase

#   alias Agileparking.{Repo, Accounts.User}
#   alias Agileparking.Guardian
#   alias Agileparking.Accounts.User

#   import Ecto.Query, only: [from: 2]

#   @create_attrs %{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678"}

#   setup do
#     user = Repo.insert!(%User{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678"})
#     conn = build_conn()
#            |> bypass_through(Agileparking.Router, [:browser, :browser_auth, :ensure_auth])
#            |> get("/")
#            |> Map.update!(:state, fn (_) -> :set end)
#            |> Guardian.Plug.sign_in(user)
#            |> send_resp(200, "Flush the session")
#            |> recycle
#     {:ok, conn: conn}
#   end


#   test "Adding card failure", %{conn: conn} do

#     conn = post conn, "/cards", %{card: [name: "farid", number: "1234567" ]}
#     assert conn.resp_body =~ ~r/Oops, something went wrong! Please check the errors below./
#   end

#   test "Adding card success", %{conn: conn} do

#     conn = post conn, "/cards", %{card: [name: "farid", number: "1234567812345678", month: "12", year: "2020", cvc: "123" ]}
#     conn = get conn, redirected_to(conn)
#     assert conn.resp_body =~ ~r/Card added successfully./
#   end
# end
