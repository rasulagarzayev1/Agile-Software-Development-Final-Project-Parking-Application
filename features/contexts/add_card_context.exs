defmodule AddCardContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias Agileparking.{Repo, Accounts.User, Sales.Zone}

  feature_starting_state fn  ->
      Application.ensure_all_started(:hound)
      %{}
    end



  given_ ~r/^I am logged in into the system$/, fn state ->
      navigate_to "/sessions/new"
      fill_field({:id, "session_email"}, "sergimartinez@gmail.cat")
      fill_field({:id, "session_password"}, "123456")
      click({:id, "submit_button"})
      :timer.sleep(1000)
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

    and_ ~r/^I fill in the card information incorrectly$/, fn state ->
      fill_field({:id, "card_name"}, "Orkhan")
      fill_field({:id, "card_month"}, "12")
      fill_field({:id, "card_year"}, "2020")
      fill_field({:id, "card_cvc"}, "123")
      {:ok, state}
    end

    when_ ~r/^I press submit$/, fn state ->
      click({:id, "submit1"})
      {:ok, state}
    end

    then_ ~r/^I should receive a rejection message$/, fn state ->
      assert visible_in_page? ~r/Oops, something went wrong! Please check the errors below./
      {:ok, state}
    end

    and_ ~r/^I fill in the card information correctly$/, fn state ->
      fill_field({:id, "card_name"}, "Orkhan")
      fill_field({:id, "card_number"}, "1234123412341234")
      fill_field({:id, "card_month"}, "12")
      fill_field({:id, "card_year"}, "2020")
      fill_field({:id, "card_cvc"}, "123")
      {:ok, state}
    end

    then_ ~r/^I should receive a confirmation message$/, fn state ->
      assert visible_in_page? ~r/Card added successfully./
      {:ok, state}
    end

end
