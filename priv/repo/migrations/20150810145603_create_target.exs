defmodule Winter.Repo.Migrations.CreateTarget do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :url, :string, null: false
      add :method, :string, null: false
      add :mission_id, references(:missions), null: false

      timestamps
    end
    create index(:targets, [:mission_id])
  end
end
