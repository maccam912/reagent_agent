defmodule ReagentAgentWeb.ReportLive.Index do
  use ReagentAgentWeb, :live_view

  alias ReagentAgent.Reports
  alias ReagentAgent.Reports.Report

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :reports, Reports.list_reports(preload: [:lot, :site]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Report")
    |> assign(:report, Reports.get_report!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Report")
    |> assign(:report, %Report{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reports")
    |> assign(:report, nil)
  end

  @impl true
  def handle_info({ReagentAgentWeb.ReportLive.FormComponent, {:saved, report}}, socket) do
    {:noreply, stream_insert(socket, :reports, report)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    report = Reports.get_report!(id)
    {:ok, _} = Reports.delete_report(report)

    {:noreply, stream_delete(socket, :reports, report)}
  end
end
