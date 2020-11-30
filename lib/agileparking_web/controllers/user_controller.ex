defmodule AgileparkingWeb.UserController do
    use AgileparkingWeb, :controller
    import Ecto.Query
    alias Agileparking.Repo
    alias Agileparking.Accounts.User
    alias Agileparking.Accounts.Card
    alias Agileparking.Repo
    alias Ecto.{Changeset, Multi}

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
            |> redirect(to: Routes.page_path(conn, :index))
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end

      def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "show.html", user: user)
      end

      def edit(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user, %{})

        render(conn, "edit.html", user: user, changeset: changeset)
      end

      def update(conn, %{"id" => id, "user" => user_params}) do
        user = Agileparking.Authentication.load_current_user(conn)
        cards = Repo.all(from c in Card, where: c.user_id == ^user.id)
        num = length(cards)
        case num > 0 do
          true ->
            map = %{}
            map = Map.put(map, :password, Agileparking.Authentication.load_current_user(conn).email)
            map = Map.put(map, :email, Agileparking.Authentication.load_current_user(conn).email)
            user = Repo.get!(User, user.id)
            {current_balance, _} = Float.parse(user.balance)
            {added_balance, _} = Float.parse(user_params["balance"])
            balance = sum(current_balance, added_balance)
            map = Map.put(map, :balance, to_string(balance))
            changeset = User.changeset(user, map)
            Repo.update!(changeset)
            conn
                |> put_flash(:info, "Balance is increased")
                |> redirect(to: Routes.user_path(conn, :index))

          _ -> conn
            |> put_flash(:error, "Please, add card!")
            |> redirect(to: Routes.user_path(conn, :index))
        end
      end

      def sum(a, b), do: a + b
  end
