defmodule RsPriceDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RsPriceDashboardWeb.Telemetry,
      RsPriceDashboard.Repo,
      {DNSCluster, query: Application.get_env(:rs_price_dashboard, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RsPriceDashboard.PubSub},
      {Registry, keys: :unique, name: RsPriceDashboard.PriceRegistry},
      {DynamicSupervisor, name: RsPriceDashboard.PriceSupervisor},
      {RsPriceDashboard.PriceEts, []},
      {RsPriceDashboard.PriceFetcher, []},
      RsPriceDashboardWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RsPriceDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RsPriceDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
