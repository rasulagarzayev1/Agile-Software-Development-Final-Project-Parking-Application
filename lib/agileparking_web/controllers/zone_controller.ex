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
  
    def index(conn, _params) do
        render(conn, "index.html", zones: [])
    end

    def create(conn, params) do
        zones = Repo.all(Zone)
        address = params["name"]
        pointA = Agileparking.Geolocation.find_location(params["name"])
        IO.inspect zones
        zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name)} end)
        IO.inspect zones
        render(conn, "index.html", zones: zones)
      end
  end