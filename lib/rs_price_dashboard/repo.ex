defmodule RsPriceDashboard.Repo do
  use Ecto.Repo,
    otp_app: :rs_price_dashboard,
    adapter: Ecto.Adapters.Postgres
end
