defmodule AgileparkingWeb.ZoneController do
    use AgileparkingWeb, :controller
    alias Agileparking.Repo
    alias Agileparking.Sales.Zone
    alias Agileparking.Forms.Zoneform

    def is_time(time) do
        IO.puts "inspecction"
        IO.inspect time
        case Time.from_iso8601(time) do
          {:ok, t} -> true
          _ -> false
        end
    end  


    def get_time(time) do
        IO.puts "inspecction"
        IO.inspect time
        case Time.from_iso8601(time) do
          {:ok, t} -> t
          _ -> false
        end
    end


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
        changeset = Zoneform.changeset(%Zoneform{}, %{})
        render(conn, "index.html", zoneform: changeset, zones: [])
    end

    def create(conn, params) do
        zones = Repo.all(Zone)
        address = params["name"]
        time = params["time"]
        milis = "00"
        time = "#{time}:#{milis}"
        now = Time.utc_now()
        now = Time.add(now, 7200, :second)

        if is_time(time) do
            tt = get_time(time)
            if (tt.minute + tt.hour*60) <= (now.minute + now.hour*60) do
                IO.puts "back to the past"
                zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),false, 0, 0} end)
                render(conn, "index.html", zones: zones)
            else
                IO.puts "correct"
                zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),true, (zone.realTimePrice*((tt.minute + tt.hour*60) - (now.minute + now.hour*60))/100), zone.hourlyPrice*tt.hour - now.hour} end)
                render(conn, "index.html", zones: zones)
            end
        else
            zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),false, 0, 0} end)
            render(conn, "index.html", zones: zones)    
        end
    end           
end
            

       # if ((params["hour"] != "") && (params["minutes"] != "")) do
       #     hour = String.to_integer(params["hour"])
       #     minutes = String.to_integer(params["minutes"])
       #     IO.puts "HA DETECTAT ALGO CREC"
       #     totalMinutes = minutes + hour*60
       #     now = Time.utc_now()
       #     totalMinutesNow = now.minute + now.hour * 60
       ####     totalHours = hour - now.hour
          #  diff = totalMinutes - totalMinutesNow
          #  pointA = Agileparking.Geolocation.find_location(params["name"])
        #    zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),true, (zone.realTimePrice *diff)/100, zone.hourlyPrice*totalHours} end)
        #    render(conn, "index.html", zones: [])
       # else
        #    zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),false, 0, 0} end)
         #   render(conn, "index.html", zones: zones)
        #end
      #end
  #end