defmodule Authy.Repo.Migrations.CreateUserType do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_type, :string
    end
  end
end
