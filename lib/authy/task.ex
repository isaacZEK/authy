defmodule Authy.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do
    field :name, :string
    field :description, :string
    field :status, :string, default: "NOT COMPLETED"
    belongs_to :user, Authy.Accounts.User
    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :user_id])
    |> validate_required([:name, :description])
  end


end
