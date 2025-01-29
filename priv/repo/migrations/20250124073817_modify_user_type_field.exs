defmodule Authy.Repo.Migrations.ModifyUserTypeField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :user_type
      add :user_type, :string, default: "USER", null: false
    end
  end
end
