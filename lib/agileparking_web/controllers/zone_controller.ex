defmodule AgileparkingWeb.ZoneController do
    use AgileparkingWeb, :controller
    import Ecto.Query
    alias Agileparking.Repo
    alias Agileparking.Sales.Zone
    alias Agileparking.Accounts.User
    alias Agileparking.Bookings.Booking
    alias Agileparking.Forms.Zoneform
    alias Ecto.{Changeset, Multi}


    def compute_hourly(time, price) do
      now = Time.utc_now()
      now = Time.add(now, 7200, :second)
      price*(time.hour - now.hour)
    end

    def compute_real_time(time, price) do
      now = Time.utc_now()
      now = Time.add(now, 7200, :second)
      Float.round(((price*((time.minute + time.hour*60) - (now.minute + now.hour*60)))/100/5),2)
    end

    def is_time(time) do
        case Time.from_iso8601(time) do
          {:ok, t} -> true
          _ -> false
        end
    end


    def get_time(time) do
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
        Enum.at(distance,0)
    end

    def index(conn, _params) do
        changeset = Zoneform.changeset(%Zoneform{}, %{})
        render(conn, "index.html", type: 3)
    end

    def filtering(list, address) do
      list
      |> Enum.filter(fn tuple -> distance(tuple.name, address ) < 500  end)
    end

    def create(conn, params) do
        type = 0
        address = params["name"]
        time = params["time"]
        query = from t in Zone, where: t.available == true, select: t
        zones = Repo.all(query)
        zones = zones |> filtering(address)
        milis = "00"
        time = "#{time}:#{milis}"
        now = Time.utc_now()
        now = Time.add(now, 7200, :second)
        p =  Agileparking.Geolocation.find_location(address)
        if ((Enum.at(p,0) == -1) or (Enum.count(zones) == 0)) do
            zones = Enum.map(zones, fn zone  -> {zone, -1,0, 0, 0} end)
            render(conn, "index.html", zones: zones,type: 0)
        else
            if is_time(time) do
                tt = get_time(time)
                if (tt.minute + tt.hour*60) <= (now.minute + now.hour*60) do
                    zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),0,0, 0} end)
                    render(conn, "index.html", zones: zones, type: 1)
                else
                    zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),0,compute_real_time(tt, zone.realTimePrice), compute_hourly(tt, zone.hourlyPrice)} end)
                    render(conn, "index.html", zones: zones, type: 2)
                end
            else
                p =  Agileparking.Geolocation.find_location(address)
                zones = Enum.map(zones, fn zone  -> {zone, distance(params["name"], zone.name),0,0, 0} end)
                render(conn, "index.html", zones: zones, type: 1)
            end
        end
    end                   

      def edit(conn, %{"id" => id}) do
        zone = Repo.get!(Zone, id)
        changeset = Zone.changeset(zone, %{})

        render(conn, "edit.html", zone: zone, changeset: changeset)
      end

      def update(conn, %{"id" => id, "zone" => zone_params}) do
        user = Agileparking.Authentication.load_current_user(conn)
        zone = Repo.get!(Zone, id)
        zone_params = Map.put(zone_params, "zoneId", id)
        zone_params = Map.put(zone_params, "paymentType", zone_params["payment_type"])

        p = case zone_params["end_date"] != "" do
            true ->
              case zone_params["payment_type"] == "Hourly" do
                true -> p = totalPriceHourly(zone_params["start_date"], zone_params["end_date"], zone.hourlyPrice)
                _ -> p = totalPriceReal(zone_params["start_date"], zone_params["end_date"],  zone.realTimePrice)
              end
          _ -> IO.puts("bye")
        end
        zone_params = Map.put(zone_params, "totalPrice", to_string(p))

          case zone_params["pay_now"] == "true" do
            true ->
                  {current_balance, _} = Float.parse(user.balance)
                  case current_balance > p do
                    true -> current_balance = sub(current_balance,p)
                    _ -> conn
                    |> put_flash(:error, "There is not enough balance. Please increase balance")
                    |> redirect(to: Routes.zone_path(conn, :index))
                  end
            _ -> IO.puts("--")
          end

          balance = case zone_params["pay_now"] == "true" do
            true ->
                  {current_balance, _} = Float.parse(user.balance)
                  case current_balance > p do
                    true -> current_balance = sub(current_balance,p)
                    _ -> current_balance = current_balance
                  end
            _ -> {current_balance, _} = Float.parse(user.balance)
                  balance = current_balance
          end

          {current_balance, _} = Float.parse(user.balance)

          paymentStatus = case zone_params["pay_now"] == "true" and balance != current_balance do
                            true -> paymentStatus = "Done"
                            _ -> paymentStatus = "Pending"
                          end

          zone_params = Map.put(zone_params, "payment_status", paymentStatus)

          map1 = %{}
          map1 = Map.put(map1, :password, Agileparking.Authentication.load_current_user(conn).email)
          map1 = Map.put(map1, :email, Agileparking.Authentication.load_current_user(conn).email)
          map1 = Map.put(map1, :balance, to_string(balance))
        case zone.available == true and ((zone_params["pay_now"] == "true" and balance != current_balance) or zone_params["pay_now"] != "true") do
          true ->

              booking_struct = Ecto.build_assoc(user, :bookings, Enum.map(zone_params, fn({key, value}) -> {String.to_atom(key), value} end))
              changeset1 = Booking.changeset(booking_struct, zone_params)
              map = %{}
              map = Map.put(map, :available, false)
              changeset2 = Zone.changeset(zone, map)
              changeset3 = User.changeset(user, map1)

              Multi.new
                |> Multi.insert(:booking, Booking.changeset(changeset1))
                |> Multi.update(:zone, Zone.changeset(changeset2))
                |> Multi.update(:user, User.changeset(changeset3))
                |> Repo.transaction

              conn
              |> put_flash(:info, "Booked successfully.")
              |> redirect(to: Routes.page_path(conn, :index))


            _ -> conn
              |> put_flash(:error, "There is no an available slot. Please choose new parking area")
              |> redirect(to: Routes.zone_path(conn, :index))

        end


      end

      def product(a, b), do: a * b
      def sum(a, b), do: a + b
      def sub(a, b), do: a - b
      def divi(a, b), do: a / b

      def totalTime(start_date, end_date) do
        {startHour, _} = Integer.parse(String.slice(start_date, 0..1))
        {startMin, _} = Integer.parse(String.slice(start_date, 3..4))
        startTotalMin = sum(product(startHour, 60),startMin)

        {endHour, _} = Integer.parse(String.slice(end_date, 0..1))
        {endMin, _} = Integer.parse(String.slice(end_date, 3..4))
        endTotalMin = sum(product(endHour, 60),endMin)
        differenceMin = sub(endTotalMin, startTotalMin)
      end

      def totalPriceHourly(start_date, end_date, hourlyPrice) do
        time = totalTime(start_date, end_date)
        case Integer.mod(time , 60) == 0 do
          true -> totalPrice = product(divi(time, 60), hourlyPrice)
          _ -> totalPrice = product(sum(divi(sub(time, Integer.mod(time , 60)), 60),1), hourlyPrice)
        end
      end

      def totalPriceReal(start_date, end_date, realTimePrice) do
        time = totalTime(start_date, end_date)
        case Integer.mod(time , 5) == 0 do
          true -> totalPrice = product(divi(time, 5), divi(realTimePrice,100))
          _ -> totalPrice = product(sum(divi(sub(time, Integer.mod(time , 5)), 5),1), divi(realTimePrice,100))
        end

      end
  end
