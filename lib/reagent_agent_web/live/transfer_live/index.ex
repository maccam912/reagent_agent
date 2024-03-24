defmodule ReagentAgentWeb.TransferLive.Index do
  use ReagentAgentWeb, :live_view

  alias ReagentAgent.Transfers
  alias ReagentAgent.Transfers.Transfer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :transfers, Transfers.list_transfers(preload: [:from, :to, :lot]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transfer")
    |> assign(:transfer, Transfers.get_transfer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transfer")
    |> assign(:transfer, %Transfer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transfers")
    |> assign(:transfer, nil)
  end

  @impl true
  def handle_info({ReagentAgentWeb.TransferLive.FormComponent, {:saved, transfer}}, socket) do
    {:noreply, stream_insert(socket, :transfers, transfer)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transfer = Transfers.get_transfer!(id)
    {:ok, _} = Transfers.delete_transfer(transfer)

    {:noreply, stream_delete(socket, :transfers, transfer)}
  end
end
