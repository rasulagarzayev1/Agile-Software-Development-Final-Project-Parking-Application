defmodule AgileparkingWeb.UserController do
    use AgileparkingWeb, :controller
    alias Agileparking.Repo
    alias Agileparking.Accounts.User


  
    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.html", users: users)
      end
  end