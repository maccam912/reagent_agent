defmodule ReagentAgent.Repo do
  use Ecto.Repo,
    otp_app: :reagent_agent,
    adapter: Ecto.Adapters.Postgres
end
