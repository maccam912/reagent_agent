defmodule ReagentAgentWeb.TransferLive.FormComponent do
  use ReagentAgentWeb, :live_component

  alias ReagentAgent.Transfers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage transfer records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="transfer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:count]} type="number" label="Count" />
        <.input field={@form[:date]} type="date" label="Date" />

        <.input field={@form[:from_id]} type="select" label="From" options={@sites |> Enum.map(&{&1.name, &1.id})} />
        <.input field={@form[:to_id]} type="select" label="To" options={@sites |> Enum.map(&{&1.name, &1.id})} />
        <.input field={@form[:lot_id]} type="select" label="Lot" options={@lots |> Enum.map(&{&1.lot_number <> " - " <> &1.reagent, &1.id})} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Transfer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{transfer: transfer} = assigns, socket) do
    changeset = Transfers.change_transfer(transfer)
    sites = ReagentAgent.Sites.list_sites()
    lots = ReagentAgent.Lots.list_lots()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:sites, sites)
     |> assign(:lots, lots)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"transfer" => transfer_params}, socket) do
    changeset =
      socket.assigns.transfer
      |> Transfers.change_transfer(transfer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"transfer" => transfer_params}, socket) do
    save_transfer(socket, socket.assigns.action, transfer_params)
  end

  defp save_transfer(socket, :edit, transfer_params) do
    case Transfers.update_transfer(socket.assigns.transfer, transfer_params) do
      {:ok, transfer} ->
        notify_parent({:saved, transfer})

        {:noreply,
         socket
         |> put_flash(:info, "Transfer updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_transfer(socket, :new, transfer_params) do
    case Transfers.create_transfer(transfer_params) do
      {:ok, transfer} ->
        notify_parent({:saved, transfer})

        {:noreply,
         socket
         |> put_flash(:info, "Transfer created successfully")
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
