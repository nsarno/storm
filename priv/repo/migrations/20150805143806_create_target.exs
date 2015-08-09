defmodule Winter.Repo.Migrations.CreateTarget do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :url, :string, null: false
      add :method, :string, null: false

      timestamps
    end

  end
end
