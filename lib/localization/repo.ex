defmodule Localization.Repo do
  use Ecto.Repo,
    otp_app: :localization,
    adapter: Ecto.Adapters.Postgres
end
