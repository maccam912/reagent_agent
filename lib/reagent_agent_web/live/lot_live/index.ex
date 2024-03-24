defmodule ReagentAgentWeb.LotLive.Index do
  use ReagentAgentWeb, :live_view

  alias ReagentAgent.Lots
  alias ReagentAgent.Lots.Lot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :lots, Lots.list_lots())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Lot")
    |> assign(:lot, Lots.get_lot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Lot")
    |> assign(:lot, %Lot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lots")
    |> assign(:lot, nil)
  end

  @impl true
  def handle_info({ReagentAgentWeb.LotLive.FormComponent, {:saved, lot}}, socket) do
    {:noreply, stream_insert(socket, :lots, lot)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lot = Lots.get_lot!(id)
    {:ok, _} = Lots.delete_lot(lot)

    {:noreply, stream_delete(socket, :lots, lot)}
  end
end
