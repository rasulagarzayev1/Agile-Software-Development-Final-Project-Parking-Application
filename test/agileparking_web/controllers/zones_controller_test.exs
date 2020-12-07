defmodule AgileparkingWeb.ZonesControllerTest do
  use AgileparkingWeb.ConnCase

  alias Agileparking.{Repo, Sales.Zone, Accounts.User}
  alias Agileparking.Guardian
  alias Agileparking.Accounts.User

  import Ecto.Query, only: [from: 2]
  @create_attrs %{name: "sergi", email: "sergi@gmail.com", license_number: "1234567889", password: "12345678"}

  def distance(placeA, placeB) do
    pointA = Agileparking.Geolocation.find_location(placeA)
    pointB = Agileparking.Geolocation.find_location(placeB)
    distance = Agileparking.Geolocation.distance(placeA, placeB)
    Enum.at(distance,0)
  end

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


  test "Only shows available", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    Repo.insert!(%Zone{name: "Puiestee 114", hourlyPrice: 2, realTimePrice: 16, available: false, zone: "B"})
    conn =
      post conn, "/zones", %{
        name: "Puiestee 110",
        time: "17:00"
      }
      assert html_response(conn, 200) =~ ~r/Puiestee 112/
      refute html_response(conn, 200) =~ ~r/Puiestee 114/
  end

  test "Only shows available among radius", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    Repo.insert!(%Zone{name: "Puiestee 114", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    conn =
    post conn, "/zones", %{
      name: "Jordi Girgona 45, Barcelona",
      time: "17:00"
    }
    refute html_response(conn, 200) =~ ~r/Puiestee 112/
    refute html_response(conn, 200) =~ ~r/Puiestee 114/
  end

  test "Zone A price shows correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"})
    conn =
    post conn, "/zones", %{
      name: "Puiestee 110",
    }
    assert html_response(conn, 200) =~ "A"
    assert html_response(conn, 200) =~ "1"
    assert html_response(conn, 200) =~ "8"
  end

  test "Zone B price shows correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    conn =
    post conn, "/zones", %{
      name: "Puiestee 110",
    }
    assert html_response(conn, 200) =~ "B"
    assert html_response(conn, 200) =~ "2"
    assert html_response(conn, 200) =~ "16"
  end


  test "Hourly price calculated correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    now = Time.utc_now()
    now = Time.add(now, 7200, :second)
    time = "23:50"
    milis = "00"
    time = "#{time}:#{milis}"
    time = elem(Time.from_iso8601(time),1)
    price = 2*(time.hour - now.hour)
    if price == 0 do price = 2 end
    conn =
    post conn, "/zones", %{
      name: "Puiestee 110",
      time: "23:50"
    }
    assert html_response(conn, 200) =~ "#{price}"
  end

  test "Real Time price calculated correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"})
    now = Time.utc_now()
    now = Time.add(now, 7200, :second)
    time = "23:50"
    milis = "00"
    time = "#{time}:#{milis}"
    time = elem(Time.from_iso8601(time),1)
    price = Float.round(((16*((time.minute + time.hour*60) - (now.minute + now.hour*60)))/100/5),2)
    conn =
    post conn, "/zones", %{
      name: "Puiestee 110",
      time: "23:50"
    }
    assert html_response(conn, 200) =~ "#{price}"
  end




end
