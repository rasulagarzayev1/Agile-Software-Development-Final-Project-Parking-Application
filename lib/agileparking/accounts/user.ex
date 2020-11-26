defmodule Agileparking.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :license_number, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :license_number])
<<<<<<< HEAD
    |> validate_required([:name, :email, :license_number, :password])
=======
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:license_number)
    |> validate_format(:email, ~r/@/)
>>>>>>> 1fb819a34ac28e61bf83eb9e9d53c6c3b0476e34
    |> validate_length(:password, min: 6)
    |> validate_length(:license_number, min: 9)
    |> hash_password
    |> unique_constraint(:email)
    |> unique_constraint(:license_number)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end
  defp hash_password(changeset), do: changeset
end
