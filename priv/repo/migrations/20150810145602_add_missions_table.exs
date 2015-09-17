defmodule Storm.Repo.Migrations.AddMissionsTable do
  use Ecto.Migration

  def change do
    create table(:missions) do
      add :name, :string, null: false
      add :load, :integer, null: false, default: 1
      add :project_id, references(:projects), null: false

      timestamps
    end
    create index(:missions, [:project_id])
  end
end
