defmodule ReagentAgentWeb.LotLive.FormComponent do
  use ReagentAgentWeb, :live_component

  alias ReagentAgent.Lots

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage lot records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="lot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:lot_number]} type="text" label="Lot number" />
        <.input field={@form[:reagent]} type="text" label="Reagent" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Lot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{lot: lot} = assigns, socket) do
    changeset = Lots.change_lot(lot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"lot" => lot_params}, socket) do
    changeset =
      socket.assigns.lot
      |> Lots.change_lot(lot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"lot" => lot_params}, socket) do
    save_lot(socket, socket.assigns.action, lot_params)
  end

  defp save_lot(socket, :edit, lot_params) do
    case Lots.update_lot(socket.assigns.lot, lot_params) do
      {:ok, lot} ->
        notify_parent({:saved, lot})

        {:noreply,
         socket
         |> put_flash(:info, "Lot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_lot(socket, :new, lot_params) do
    case Lots.create_lot(lot_params) do
      {:ok, lot} ->
        notify_parent({:saved, lot})

        {:noreply,
         socket
         |> put_flash(:info, "Lot created successfully")
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
