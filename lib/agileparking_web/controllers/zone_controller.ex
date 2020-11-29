defmodule AgileparkingWeb.ZoneController do
    use AgileparkingWeb, :controller
    alias Agileparking.Repo
    alias Agileparking.Sales.Zone

    def distance(placeA, placeB) do
        pointA = Agileparking.Geolocation.find_location(placeA)
        pointB = Agileparking.Geolocation.find_location(placeB)
        distance = Agileparking.Geolocation.distance(placeA, placeB)
        IO.puts "hola que tal"
        IO.inspect distance
        Enum.at(distance,0)
    end

    def show(conn, %{"id" => id}) do
        zone = Repo.get!(Zone, id)
        render(conn, "show.html", zone: zone)
    end
  
    def index(conn, _params) do
        render(conn, "index.html", zones: [])
    end

    def create(conn, params) do
        zones = Repo.all(Zone)
        address = params["name"]

        if ((params["hour"] != "") && (params["minutes"] != "")) do
            hour = String.to_integer(params["hour"])
            minutes = String.to_integer(params["minutes"])
            IO.puts "HA DETECTAT ALGO CREC"
            totalMinutes = minutes + hour*60
            now = Time.utc_now()
            totalMinutesNow = now.minute + now.hour * 60
            totalHours = hour - now.hour
            diff = totalMinutes - totalMinutesNow
            pointA = Agileparking.Geolocation.find_location(params["name"])
            zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),true, (zone.realTimePrice *diff)/100, zone.hourlyPrice*totalHours} end)
            render(conn, "index.html", zones: zones)
        else
            zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),false, 0, 0} end)
            render(conn, "index.html", zones: zones)
        end
      end
  end