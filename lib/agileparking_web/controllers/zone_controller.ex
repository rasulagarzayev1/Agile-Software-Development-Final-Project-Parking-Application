defmodule AgileparkingWeb.ZoneController do
    use AgileparkingWeb, :controller
    import Ecto.Query
    alias Agileparking.Repo
    alias Agileparking.Sales.Zone

    def show(conn, %{"id" => id}) do
        zone = Repo.get!(Zone, id)
        render(conn, "show.html", zone: zone)
      end

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

      def edit(conn, %{"id" => id}) do
        zone = Repo.get!(Zone, id)
        changeset = Zone.changeset(zone, %{})

        render(conn, "edit.html", zone: zone, changeset: changeset)
      end

      def update(conn, %{"id" => id, "zone" => zone_params}) do
        zone = Repo.get!(Zone, id)
        case zone.vacant > 0 do
          true ->
              map = %{}
              map = Map.put(map, :vacant, sub(zone.vacant, 1))
              changeset = Zone.changeset(zone, map)
              Repo.update!(changeset)
              zone = Repo.get!(Zone, id)
              conn
              |> put_flash(:info, "Booked successfully.")
              |> redirect(to: Routes.page_path(conn, :index))


            _ -> conn
              |> put_flash(:error, "There is no an available slot. Please choose new parking area")
              |> redirect(to: Routes.zone_path(conn, :index))

        end


      end

      def sub(a, b), do: a - b
  end
