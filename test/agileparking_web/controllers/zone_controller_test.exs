defmodule AgileparkingWeb.ZoneControllerTest do
    use AgileparkingWeb.ConnCase

    alias Agileparking.{Repo, Accounts.User, Sales.Zone}
    alias Agileparking.Guardian
    alias Agileparking.Accounts.User
    alias Agileparking.Sales.Zone

  
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
  
    test "Page render", %{conn: conn} do
      conn = get(conn, Routes.zone_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing parking loots"
    end

    test "Distance calculator", %{conn: conn} do
      placeA = "Jakobi"
      placeB = "Tahtvere 48, Tartu"
      distance = Agileparking.Geolocation.distance(placeA, placeB)
      assert distance = 145.81
    end

    test "Introducing an address gives results", %{conn: conn} do
      conn = post conn, "/zones", %{
        "_csrf_token" => "Njt5ZhIDWF48D3RjJFMWBhEjDTsXJwoAlP79w2l8ilGTV4CNwPkpOQNG",
        "hour" => "",
        "minutes" => "",
        "name" => "barcelona"
      }
      assert html_response(conn, 200) =~ "Listing parking loots"
    end
  end
  