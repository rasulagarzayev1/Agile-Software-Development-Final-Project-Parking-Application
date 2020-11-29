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
        [%{name: "sergi", email: "sergimartinez@gmail.cat", license_number: "123456789", password: "123456"}]
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



end
