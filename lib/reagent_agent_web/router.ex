defmodule ReagentAgentWeb.Router do
  use ReagentAgentWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ReagentAgentWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReagentAgentWeb do
    pipe_through :browser

    live "/lots", LotLive.Index, :index
    live "/lots/new", LotLive.Index, :new
    live "/lots/:id/edit", LotLive.Index, :edit

    live "/lots/:id", LotLive.Show, :show
    live "/lots/:id/show/edit", LotLive.Show, :edit

    live "/sites", SiteLive.Index, :index
    live "/sites/new", SiteLive.Index, :new
    live "/sites/:id/edit", SiteLive.Index, :edit

    live "/sites/:id", SiteLive.Show, :show
    live "/sites/:id/show/edit", SiteLive.Show, :edit

    live "/orders", OrderLive.Index, :index
    live "/orders/new", OrderLive.Index, :new
    live "/orders/:id/edit", OrderLive.Index, :edit

    live "/orders/:id", OrderLive.Show, :show
    live "/orders/:id/show/edit", OrderLive.Show, :edit

    live "/reports", ReportLive.Index, :index
    live "/reports/new", ReportLive.Index, :new
    live "/reports/:id/edit", ReportLive.Index, :edit

    live "/reports/:id", ReportLive.Show, :show
    live "/reports/:id/show/edit", ReportLive.Show, :edit

    live "/transfers", TransferLive.Index, :index
    live "/transfers/new", TransferLive.Index, :new
    live "/transfers/:id/edit", TransferLive.Index, :edit

    live "/transfers/:id", TransferLive.Show, :show
    live "/transfers/:id/show/edit", TransferLive.Show, :edit

    live "/", MetricsLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReagentAgentWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:reagent_agent, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ReagentAgentWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
