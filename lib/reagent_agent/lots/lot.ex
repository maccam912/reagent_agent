defmodule ReagentAgent.Lots.Lot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lots" do
    field :lot_number, :string
    field :reagent, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lot, attrs) do
    lot
    |> cast(attrs, [:lot_number, :reagent])
    |> validate_required([:lot_number, :reagent])
  end
end
