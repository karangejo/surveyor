defmodule Surveyor.Repo do
  use Ecto.Repo,
    otp_app: :surveyor,
    adapter: Ecto.Adapters.Postgres
end
