defmodule AgileparkingWeb.UsersControllerTest do
  use AgileparkingWeb.ConnCase

  test "POST /users", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "Liivi 2", email: "muuseumi@gmail.com", license_number: "dfghjgkfldks", password: "1234567" ]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/User created successfully./
  end
end
