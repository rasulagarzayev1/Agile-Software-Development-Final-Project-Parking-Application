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
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true})
    Repo.insert!(%Zone{name: "Puiestee 114", hourlyPrice: 2, realTimePrice: 16, available: false})
    query = from t in Zone, where: t.available == true, select: t
    t1 = Repo.all(query)
    assert  Enum.count(t1) == 1
  end

  test "Only shows available among radius", %{conn: conn} do
    address = "Puiestee 110"
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true})
    Repo.insert!(%Zone{name: "Barcelona", hourlyPrice: 2, realTimePrice: 16, available: true})
    query = from t in Zone, where: t.available == true, select: t
    t1 = Repo.all(query)
    assert  Enum.count(t1) == 1
  end

  test "Zone A price shows correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 1, realTimePrice: 8, available: true})
    
    conn = post conn, "/zones", %{
      "_csrf_token" => "Njt5ZhIDWF48D3RjJFMWBhEjDTsXJwoAlP79w2l8ilGTV4CNwPkpOQNG",
      "name" => "barcelona"
    }
    assert html_response(conn, 200) =~ "1"

  end

  test "Zone B price shows correctly", %{conn: conn} do
    Repo.insert!(%Zone{name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true})
    
    conn = post conn, "/zones", %{
      "_csrf_token" => "Njt5ZhIDWF48D3RjJFMWBhEjDTsXJwoAlP79w2l8ilGTV4CNwPkpOQNG",
      "name" => "barcelona"
    }
    assert html_response(conn, 200) =~ "2"
  end
  
  
  test "Hourly price calculated correctly", %{conn: conn} do
    #todo
    price = 2
    assert  price == 1
  end

  test "Real time price calculated correctly", %{conn: conn} do
    #todo
    price = 2
    assert  price == 1
  end




end
