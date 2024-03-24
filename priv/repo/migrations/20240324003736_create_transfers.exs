defmodule ReagentAgent.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :date, :date
      add :count, :integer
      add :from_id, references(:sites, on_delete: :delete_all)
      add :to_id, references(:sites, on_delete: :delete_all)
      add :lot_id, references(:lots, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:transfers, [:date, :from_id, :to_id, :lot_id])
  end
end
