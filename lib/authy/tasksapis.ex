defmodule Authy.Tasksapis do
  import Ecto.Query, warn: false
  alias Authy.{Repo, Tasksapi}  # Correct alias for Repo and Tasksapi schema

  # Create a new task
  def create_tasks(attrs \\ %{}) do
    %Tasksapi{} # Ensure this refers to the correct schema
    |> Tasksapi.changeset(attrs)
    |> Repo.insert()
  end

  # List all tasks
  # Authy.Tasksapis.list_tasks
  def list_tasks do
  Repo.all(Tasksapi)
    # IO.inspect(list, label: "viewing tasks")
  end

  # Fetch a task by ID
  def get_task!(task_id) do
    Repo.get!(Tasksapi, task_id)
  end

  # Update a task
  def update_task(%Tasksapi{} = task, attrs) do
    task
    |> Tasksapi.changeset(attrs)  # Fixed incorrect module reference
    |> Repo.update()
  end

  # Delete a task (permanently)
  def delete_task(task_id) do
    task = Repo.get!(Tasksapi, task_id)
    case task do
      nil -> {:error, "Task not found"}
      task -> Repo.delete(task)
    end
  end

  # Soft delete a task (marks it as deleted instead of removing it)
  # def soft_delete_task(%Tasksapi{} = task) do
  #   task
  #   |> Tasksapi.changeset(%{"deleted_at" => DateTime.utc_now()})
  #   |> Repo.update()
  # end

  # Mark task as completed
  def task_completed(%Tasksapi{} = task) do
    task
    |> Tasksapi.changeset(%{"status" => "COMPLETED"})
    |> Repo.update()
  end


end
