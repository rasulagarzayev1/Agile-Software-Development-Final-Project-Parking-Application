defmodule AgileparkingWeb.UsersControllerTest do
  use AgileparkingWeb.ConnCase

  alias Agileparking.{Repo, Accounts.User}
  alias Agileparking.Guardian
  alias Agileparking.Accounts.User

  import Ecto.Query, only: [from: 2]

  @create_attrs %{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678", balance: "3.45"}

  setup do
    user = Repo.insert!(%User{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678", balance: "3.45"})
    conn = build_conn()
           |> bypass_through(Agileparking.Router, [:browser, :browser_auth, :ensure_auth])
           |> get("/")
           |> Map.update!(:state, fn (_) -> :set end)
           |> Guardian.Plug.sign_in(user)
           |> send_resp(200, "Flush the session")
           |> recycle
    {:ok, conn: conn}
  end

  test "lists all users", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "User registers correctly", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "fred1", email: "farid@gmail.com", license_number: "1234567676", password: "parool" ]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/User created successfully./
  end

  test "User registers failure", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "fred1", email: "farid", license_number: "1234567676", password: "parool" ]}

    assert conn.resp_body =~ ~r/Oops, something went wrong! Please check the errors below./
  end

  test "New user shows correctly", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "New User"
  end

  test "Increase balance failure", %{conn: conn} do

    conn = put conn, "/users/1", %{id: 1, user: [name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678", balance: "3.45"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/Please, add card!/
  end

  test "Increase balance success", %{conn: conn} do
    conn = post conn, "/cards", %{card: [name: "sergi", number: "1234567812345678", month: "12", year: "2020", cvc: "123" ]}
    conn = put conn, "/users/1", %{id: 1, user: [name: "sergi", email: "sergi@gmail", license_number: "1234567889", password: "12345678", balance: "3.45"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/Balance is increased/
  end

end
