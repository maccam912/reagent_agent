defmodule ReagentAgent.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string, unique: true

      timestamps(type: :utc_datetime)
    end
  end
end
