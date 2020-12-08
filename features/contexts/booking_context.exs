defmodule BookingContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias Agileparking.{Repo, Accounts.User, Sales.Zone}

  feature_starting_state fn  ->
      Application.ensure_all_started(:hound)
      %{}
    end


    scenario_starting_state fn _state ->
      Hound.start_session
      Ecto.Adapters.SQL.Sandbox.checkout(Agileparking.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Agileparking.Repo, {:shared, self()})
      # Register and login new user for BDD tests
      [%{name: "sergi", email: "sergimartinez@gmail.cat", license_number: "123456789", password: "123456", balance: "12", monthly_bill: "0"}]
      |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
      |> Enum.each(fn changeset -> Repo.insert!(changeset) end)


    # Create parking spots

    [%{name: "Puiestee 114", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "B"},
     %{name: "Puiestee 113", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"}]
    |> Enum.map(fn zone_data -> Zone.changeset(%Zone{}, zone_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)


    end

    scenario_finalize fn _status, _state ->
      Ecto.Adapters.SQL.Sandbox.checkin(Agileparking.Repo)
    end

  given_ ~r/^I am logged in into the system$/, fn state ->
    navigate_to "/sessions/new"
    fill_field({:id, "session_email"}, "sergimartinez@gmail.cat")
    fill_field({:id, "session_password"}, "123456")
    click({:id, "submit_button"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I am on the zones pages$/, fn state ->
    navigate_to "/zones"
    {:ok, state}
  end

  and_ ~r/^I fill in the destination form with "(?<argument_one>[^"]+)"$/,
  fn state, %{argument_one: argument_one} ->
    fill_field({:id, "name"}, argument_one)
    {:ok, state}
  end

  and_ ~r/^I fill in the leaving time with "(?<argument_one>[^"]+)"$/,
  fn state, %{argument_one: argument_one} ->
    fill_field({:id, "time"}, argument_one)
    {:ok, state}
  end

  and_ ~r/^I press submit1$/, fn state ->
    click({:id, "search"})
    :timer.sleep(20000)
    {:ok, state}
  end

  and_ ~r/^I should receive a table with all the available spaces and their respective distances$/, fn state ->
    assert visible_in_page? ~r/Name/
      assert visible_in_page? ~r/Hourly rate/
      assert visible_in_page? ~r/Real Time rate/
      assert visible_in_page? ~r/Distance/
      assert (find_all_elements(:id, "zones-table") |> Enum.count) > 0
      {:ok, state}
  end

  and_ ~r/^I click goShowDetail button and go show booking page$/, fn state ->
    click({:id, "goShowDetail"})
    :timer.sleep(5000)
    {:ok, state}
  end

  and_ ~r/^I am on the zones edit page$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^I click add button and go zones edit page$/, fn state ->
    click({:id, "add"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I click the payment type$/, fn state ->
    click({:id, "PaymentType"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I select hourly payment type$/, fn state ->
    click({:id, "1"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I select real payment type$/, fn state ->
  click({:id, "2"})
  :timer.sleep(1000)
  {:ok, state}
  end

  and_ ~r/^I fill start and end date with "(?<argument_one>[^"]+)" and "(?<argument_two>[^"]+)"$/,
  fn state, %{argument_one: argument_one,argument_two: argument_two} ->\
    fill_field({:id, "zone_start_date"}, argument_one)
    fill_field({:id, "zone_end_date"}, argument_two)
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I press submit2$/, fn state ->
    click({:id, "submit"})
    :timer.sleep(1000)
    {:ok, state}
  end

  then_ ~r/^I should recieve success message$/, fn state ->
    assert visible_in_page? ~r/Booked successfully./
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I am on the bookings page$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^I click extend button$/, fn state ->
    click({:id, "extend"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I fill end date with "(?<argument_one>[^"]+)"$/,
  fn state, %{argument_one: argument_one} ->
    fill_field({:id, "booking_end_date"}, argument_one)
    :timer.sleep(1000)
    {:ok, state}
  end

  then_ ~r/^I should recieve success message1$/, fn state ->
    assert visible_in_page? ~r/Succesfully updated/
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I click checkbox$/, fn state ->
    click({:id, "pay"})
    :timer.sleep(1000)
    {:ok, state}
  end

  and_ ~r/^I click finish button$/, fn state ->
    click({:id, "finish"})
    :timer.sleep(1000)
    {:ok, state}
  end

  then_ ~r/^I should recieve success message2$/, fn state ->
    assert visible_in_page? ~r/Booking finished succesfully/
    :timer.sleep(1000)
    {:ok, state}
  end

end
