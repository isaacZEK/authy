defmodule Authy.Repo.Migrations.CreateTaskTable do
  use Ecto.Migration

  def change do
    create table(:tasksapi) do
      add :name, :string
      add :description, :string
      add :status, :string, size: 20
      timestamps()
    end
  end
end
