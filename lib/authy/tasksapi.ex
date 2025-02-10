defmodule Authy.Tasksapi do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :description, :status, :inserted_at, :updated_at]}

  schema "tasksapi" do
    field :name, :string
    field :description, :string
    field :status, :string, default: "NOT COMPLETED"
    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status])
    |> validate_required([:name, :description])
  end


end
