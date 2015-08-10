defmodule Storm.Repo.Migrations.CreateMission do
  use Ecto.Migration

  def change do
    create table(:missions) do
      add :name, :string, null: false
      add :project_id, references(:projects), null: false

      timestamps
    end
    create index(:missions, [:project_id])
  end
end
