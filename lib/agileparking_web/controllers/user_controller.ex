defmodule AgileparkingWeb.UserController do
    use AgileparkingWeb, :controller
    alias Agileparking.Repo
    alias Agileparking.Accounts.User



    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.html", users: users)
      end

      def new(conn, _params) do
        changeset = User.changeset(%User{}, %{})
        render(conn, "new.html", changeset: changeset)
      end

      def create(conn, %{"user" => user_params}) do
        changeset = User.changeset(%User{}, user_params)

        case Repo.insert(changeset) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: Routes.user_path(conn, :index))
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end
  end
