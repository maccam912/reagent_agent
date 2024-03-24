defmodule ReagentAgent.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :count, :integer
    field :date, :date
    belongs_to :lot, ReagentAgent.Lots.Lot
    belongs_to :site, ReagentAgent.Sites.Site

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:date, :count, :lot_id, :site_id])
    |> validate_required([:date, :count, :lot_id, :site_id])
    |> validate_number(:count, greater_than_or_equal_to: 1)
  end
end
