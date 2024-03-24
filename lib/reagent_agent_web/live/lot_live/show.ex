defmodule ReagentAgentWeb.LotLive.Show do
  use ReagentAgentWeb, :live_view

  alias ReagentAgent.Lots

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:lot, Lots.get_lot!(id))}
  end

  defp page_title(:show), do: "Show Lot"
  defp page_title(:edit), do: "Edit Lot"
end
