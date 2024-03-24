defmodule ReagentAgent.Repo.Migrations.CreateLots do
  use Ecto.Migration

  def change do
    create table(:lots) do
      add :lot_number, :string, unique: true
      add :reagent, :string

      timestamps(type: :utc_datetime)
    end
  end
end
