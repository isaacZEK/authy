defmodule Authy.Tasks do
  import Ecto.Query, warn: false
  alias Authy.Repo
  alias Authy.Task
  # alias Authy.Accounts.User

  def create_task(attrs \\%{}, user_id) do
    # Merge the user_id into the attributes
    attrs = Map.put(attrs, "user_id", user_id)
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def list_tasks(user_id) do
    Repo.all(from t in Task, where: t.status not in ["DELETED"] and t.user_id == ^user_id )
  end

  def list_task!(task_id) do
    Task
    |> where([t], t.status not in ["DELETED"] and t.id == ^task_id)
    |> Repo.one!()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def soft_delete(%Task{} = task) do
    task
    |> Task.changeset(%{"status" => "DELETED"})
    |> Repo.update()
  end

  def task_completed(%Task{} = task) do
    task
    |> Task.changeset(%{"status" => "COMPLETED"})
    |> Repo.update()
  end

  def task_undone(%Task{} = task) do
    task
    |> Task.changeset(%{"status" => "NOT COMPLETED"})
    |> Repo.update()
  end

  def task_status(%Task{} = task) do
    task
    |>Task.changeset(%{status: true})
    |> Repo.update()
  end



    def change_task(%Task{} = task, attrs \\ %{}) do
      Task.changeset(task, attrs)
    end

    def change_task_update(%Task{} = task) do
      task
      |> Task.changeset(%{})
    end

end
