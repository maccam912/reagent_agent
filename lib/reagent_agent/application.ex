defmodule ReagentAgent.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReagentAgentWeb.Telemetry,
      ReagentAgent.Repo,
      {DNSCluster, query: Application.get_env(:reagent_agent, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ReagentAgent.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ReagentAgent.Finch},
      # Start a worker by calling: ReagentAgent.Worker.start_link(arg)
      # {ReagentAgent.Worker, arg},
      # Start to serve requests, typically the last entry
      ReagentAgentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReagentAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReagentAgentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
