defmodule AgileparkingWeb.SessionsControllerTest do
  use AgileparkingWeb.ConnCase
  alias Agileparking.Repo
  alias Agileparking.Accounts.User

  test "Test login", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "Liivi 2", email: "muuseumi@gmail.com", license_number: "dfghjgkfldks", password: "1234567" ]}
    conn = post conn, "/sessions", %{session: [email: "muuseumi@gmail.com", password: "1234567" ]}
    conn = get conn, redirected_to(conn)
    assert conn.resp_body =~ ~r/Welcome/
  end

end
