defmodule ReagentAgentWeb.ReportLive.FormComponent do
  use ReagentAgentWeb, :live_component

  alias ReagentAgent.Reports

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage report records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="report-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:count]} type="number" label="Count" />

        <.input type="select" field={@form[:lot_id]} label="Lot" options={@lots |> Enum.map(&{&1.lot_number <> " - " <> &1.reagent, &1.id})} />
        <.input type="select" field={@form[:site_id]} label="Site" options={@sites |> Enum.map(&{&1.name, &1.id})} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Report</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{report: report} = assigns, socket) do
    changeset = Reports.change_report(report)
    lots = ReagentAgent.Lots.list_lots()
    sites = ReagentAgent.Sites.list_sites()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:lots, lots)
     |> assign(:sites, sites)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"report" => report_params}, socket) do
    changeset =
      socket.assigns.report
      |> Reports.change_report(report_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"report" => report_params}, socket) do
    save_report(socket, socket.assigns.action, report_params)
  end

  defp save_report(socket, :edit, report_params) do
    case Reports.update_report(socket.assigns.report, report_params) do
      {:ok, report} ->
        notify_parent({:saved, report})

        {:noreply,
         socket
         |> put_flash(:info, "Report updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_report(socket, :new, report_params) do
    case Reports.create_report(report_params) do
      {:ok, report} ->
        notify_parent({:saved, report})

        {:noreply,
         socket
         |> put_flash(:info, "Report created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
