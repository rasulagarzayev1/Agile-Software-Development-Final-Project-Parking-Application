defmodule Agileparking.Repo do
  use Ecto.Repo,
    otp_app: :agileparking,
    adapter: Ecto.Adapters.Postgres
end
