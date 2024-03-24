defmodule ReagentAgent.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :date, :date
      add :count, :integer
      add :lot_id, references(:lots, on_delete: :delete_all)
      add :site_id, references(:sites, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:reports, [:date, :lot_id, :site_id])
  end
end
