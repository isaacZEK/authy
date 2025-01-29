defmodule Authy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthyWeb.Telemetry,
      Authy.Repo,
      {DNSCluster, query: Application.get_env(:authy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Authy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Authy.Finch},
      # Start a worker by calling: Authy.Worker.start_link(arg)
      # {Authy.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Authy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
