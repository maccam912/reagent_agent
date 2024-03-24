defmodule ReagentAgent.Transfers.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :count, :integer
    field :date, :date
    belongs_to :from, ReagentAgent.Sites.Site
    belongs_to :to, ReagentAgent.Sites.Site
    belongs_to :lot, ReagentAgent.Lots.Lot

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:count, :date, :from_id, :to_id, :lot_id])
    |> validate_required([:count, :date, :from_id, :to_id, :lot_id])
    |> validate_number(:count, greater_than: 0)
  end
end
