defmodule Winter.Repo.Migrations.CreateTarget do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :method, :string
      add :url, :string

      timestamps
    end

  end
end
