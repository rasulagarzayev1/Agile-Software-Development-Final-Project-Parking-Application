defmodule AgileparkingWeb.SessionController do
  use AgileparkingWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Agileparking.Authentication.check_credentials(conn, username, password, repo: Agileparking.Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Bad credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Agileparking.Authentication.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
