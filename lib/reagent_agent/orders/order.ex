defmodule ReagentAgent.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :date, :date
    field :count, :integer
    belongs_to :lot, ReagentAgent.Lots.Lot
    belongs_to :site, ReagentAgent.Sites.Site

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:date, :count, :lot_id, :site_id])
    |> validate_required([:date, :count, :lot_id, :site_id])
    |> validate_number(:count, greater_than: 0)
  end
end
