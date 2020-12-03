defmodule AgileparkingWeb.ZonesControllerTest do
  use AgileparkingWeb.ConnCase
  test "Introducing a wrong address gives error results", %{conn: conn} do
    conn = post conn, "/zones", %{
      "_csrf_token" => "Njt5ZhIDWF48D3RjJFMWBhEjDTsXJwoAlP79w2l8ilGTV4CNwPkpOQNG",
      "hour" => "",
      "minutes" => "",
      "name" => "..............."
    }
    assert html_response(conn, 200) =~ "Incorrect address"
  end

  test "Introducing an address and time gives good results", %{conn: conn} do
    conn = post conn, "/zones", %{
      "_csrf_token" => "Njt5ZhIDWF48D3RjJFMWBhEjDTsXJwoAlP79w2l8ilGTV4CNwPkpOQNG",
      "hour" => "5",
      "minutes" => "6",
      "name" => "barcelona"
    }
    assert html_response(conn, 200) =~ "hourly price"
  end

end
