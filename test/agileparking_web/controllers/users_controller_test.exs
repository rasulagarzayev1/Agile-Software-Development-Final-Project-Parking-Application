defmodule AgileparkingWeb.UsersControllerTest do
  use AgileparkingWeb.ConnCase

<<<<<<< HEAD
  alias Agileparking.{Repo, Accounts.User}
  alias Agileparking.Guardian
  alias Agileparking.Accounts.User

  import Ecto.Query, only: [from: 2]

  @create_attrs %{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678"}

  setup do
    user = Repo.insert!(%User{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678"})
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

  test "New user shows correctly", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "New User"
  end
=======
  test "POST /users", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "Liivi 2", email: "muuseumi@gmail.com", license_number: "dfghjgkfldks", password: "1234567" ]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/User created successfully./
  end
>>>>>>> 1fb819a34ac28e61bf83eb9e9d53c6c3b0476e34
end
