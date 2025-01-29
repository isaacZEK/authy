defmodule Authy.Repo.Migrations.CreateDeleteField do
  use Ecto.Migration

  def change do
    alter table(:users) do
     add :delete_status, :string, default: "NOT DELETED"
    end
  end
end
