defmodule Authy.Repo.Migrations.CreateUserIdInTasks do
  use Ecto.Migration

  def change do
    alter table(:task) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
    create index(:task, [:user_id])
  end
end
