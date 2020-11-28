defmodule AgileparkingWeb.CardController do
  use AgileparkingWeb, :controller
  alias Agileparking.Repo
  alias Agileparking.Accounts.Card
  import Ecto.Query

  def index(conn, _params) do
    user = Agileparking.Authentication.load_current_user(conn)
    cards = Repo.all(from c in Card, where: c.user_id == ^user.id)
    render conn, "index.html", cards: cards
  end

  def new(conn, _params) do
    changeset = Card.changeset(%Card{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"card" => card_params}) do
    user = Agileparking.Authentication.load_current_user(conn)

    card_struct = Ecto.build_assoc(user, :cards, Enum.map(card_params, fn({key, value}) -> {String.to_atom(key), value} end))
    changeset = Card.changeset(card_struct, %{})

    case Repo.insert(changeset) do
      {:ok, _card} ->
        conn
        |> put_flash(:info, "Card added successfully.")
        |> redirect(to: Routes.card_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
