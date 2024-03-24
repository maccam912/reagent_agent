defmodule ReagentAgentWeb.TransferLive.Show do
  use ReagentAgentWeb, :live_view

  alias ReagentAgent.Transfers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:transfer, Transfers.get_transfer!(id, preload: [:from, :to, :lot]))}
  end

  defp page_title(:show), do: "Show Transfer"
  defp page_title(:edit), do: "Edit Transfer"
end
