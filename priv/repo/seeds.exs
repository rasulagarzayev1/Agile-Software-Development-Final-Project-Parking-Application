# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Agileparking.Repo.insert!(%Agileparking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Agileparking.{Repo, Accounts.User, Sales.Zone}

[%{name: "Fred Flintstone", email: "fred@gmail.com", password: "parool", license_number: "123456789", balance: "12.43", monthly_bill: "0"},
 %{name: "Barney Rubble", email: "barney@gmail.com", password: "parool", license_number: "12345678a", balance: "0", monthly_bill: "0"}]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)



[%{id: 1, name: "Puiestee 112", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"}, %{id: 2, name: "Puiestee 113", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"},
%{id: 3, name: "Puiestee 114", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"}, %{id: 4,name: "Puiestee 115", hourlyPrice: 2, realTimePrice: 16, available: true, zone: "A"}]
|> Enum.map(fn zone_data -> Zone.changeset(%Zone{}, zone_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
