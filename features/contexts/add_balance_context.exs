defmodule AddBalanceContext do
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
        [%{name: "orkhan", email: "orkhan97@gmail.cat", license_number: "123456789a", password: "123456", balance: "12"}]
        |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
        |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

      end

    given_ ~r/^I am logged in into the system$/, fn state ->
        navigate_to "/sessions/new"
        fill_field({:id, "session_email"}, "sergimartinez@gmail.cat")
        fill_field({:id, "session_password"}, "123456")
        click({:id, "submit_button"})
        :timer.sleep(1000)
        {:ok, state}
      end

    and_ ~r/^I am on the users pages$/, fn state ->
        navigate_to "/users/"
        {:ok, state}
    end

    and_ ~r/^I press show button$/, fn state ->
      click({:id, "show"})
      :timer.sleep(1000)
      {:ok, state}
    end

    and_ ~r/^I press add balance button$/, fn state ->
      click({:id, "add"})
      :timer.sleep(1000)
      {:ok, state}
    end

    and_ ~r/^I fill in the form with "(?<argument_one>[^"]+)"$/,
    fn state, %{argument_one: argument_one} ->
      fill_field({:id, "user_balance"}, argument_one)
      :timer.sleep(1000)
      {:ok, state}
    end

    when_ ~r/^I press submit$/, fn state ->
      click({:id, "submit"})
      :timer.sleep(1000)
      {:ok, state}
    end

    then_ ~r/^I should receive a rejection message$/, fn state ->
      assert visible_in_page? ~r/Please, add card!/
      {:ok, state}
    end


    and_ ~r/^I am on the cards pages$/, fn state ->
      navigate_to "/cards/"
      {:ok, state}
    end

    and_ ~r/^I press add card button$/, fn state ->
      click({:id, "add"})
      :timer.sleep(1000)
      {:ok, state}
    end

    and_ ~r/^I fill in the card information$/, fn state ->
      fill_field({:id, "card_name"}, "Orkhan")
      fill_field({:id, "card_number"}, "1234123412341234")
      fill_field({:id, "card_month"}, "12")
      fill_field({:id, "card_year"}, "2020")
      fill_field({:id, "card_cvc"}, "123")
      :timer.sleep(1000)
      {:ok, state}
    end

    when_ ~r/^I press submit1$/, fn state ->
      click({:id, "submit1"})
      :timer.sleep(1000)
      {:ok, state}
    end

    then_ ~r/^I should receive a confirmation message$/, fn state ->
      assert visible_in_page? ~r/Card added successfully./
      {:ok, state}
    end

    then_ ~r/^I should receive a confirmation message about increased balance$/, fn state ->
      assert visible_in_page? ~r/Balance is increased/
      {:ok, state}
    end
end
