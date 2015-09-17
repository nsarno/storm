defmodule Storm.Repo.Migrations.AddProjectsTable do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :user_id, references(:users), null: false

      timestamps
    end

    create index(:projects, [:user_id])
  end
end
