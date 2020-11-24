defmodule AgileparkingWeb.UsersControllerTest do
  use AgileparkingWeb.ConnCase


  test "Test registration", %{conn: conn} do
    conn = post conn, "/users", %{user: [name: "fred1", email: "farid@gmail.com", license_number: "1234567676", password: "parool" ]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/User created successfully./
  end
end
