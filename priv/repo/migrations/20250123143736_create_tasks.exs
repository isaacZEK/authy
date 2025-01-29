defmodule Authy.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :name, :string
      add :description, :string
      add :status, :string, size: 20

      timestamps()
    end
  end
end
