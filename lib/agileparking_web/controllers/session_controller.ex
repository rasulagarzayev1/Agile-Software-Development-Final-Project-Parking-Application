defmodule AgileparkingWeb.SessionController do
  use AgileparkingWeb, :controller
  alias Agileparking.{Authentication, Repo}
  alias Agileparking.Accounts.User
  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    case Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> Authentication.login(user)
        |> put_flash(:info, "Welcome #{email}")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error,"Bad User Credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Agileparking.Authentication.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end


