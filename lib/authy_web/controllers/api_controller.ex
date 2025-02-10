defmodule AuthyWeb.ApiController do
  use AuthyWeb, :controller
  alias Authy.Tasks
  alias Authy.Tasksapis
  alias Authy.Accounts

  # Create a task
  def create(conn, %{"tasks" => task_params}) do
    case Tasksapis.create_tasks(task_params) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Task has been created", task: task})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  # List all tasks
  def index(conn, _params) do
    case Tasksapis.list_tasks() do
      [] ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "failed to load tasks", tasks: nil})

        tasks ->
          conn
          |> put_status(:ok)
          |> json(%{message: "tasks have been listed", tasks: tasks})
    end
  end

  # Show a specific task
  def show(conn, %{"id" => id}) do
    case Tasksapis.get_task!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Task not found"})

      task ->
        conn
        |> put_status(:ok)
        |> json( %{task: task})

        #another way to fetch tasks
        # |> json(%{task: Map.from_struct(task)
        #                |>Map.delete(:__meta__)})

      end
  end

  # Update a task
  def update(conn, %{"id" => id, "tasks" => task_params}) do
    case Tasksapis.get_task!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Task not found"})

      task ->
        case Tasksapis.update_task(task, task_params) do
          {:ok, updated_task} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Task updated successfully", task: updated_task})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset.errors})
        end
    end
  end

  # Delete a task
  def delete(conn, %{"id" => id}) do
        case Tasksapis.delete_task(id) do
          {:ok, deleted_task} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Task has been deleted successfully", task: deleted_task})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset.errors})
        end
  end


  ##########################################
  ##########################################
  ###CREATING APIs FOR TASKS WITH USER ID###
  ##########################################
  ##########################################

def login(conn, %{"email" => email, "passsword" => password}) do
  case Accounts.authenticate_user(email, password) do
    {:ok, user} ->
      {:ok, token, _claims} = Authy.Guardian.encode_and_sign(user, %{})

      conn
      |> put_status(:ok)
      |> json(%{token: token, user: user})

    {:error, :unauthorized} ->
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Invalid credentials"})
  end
end

def create_user_task(conn, %{"task" => task_params}) do
   user_id = conn.assigns.current_user.id
   IO.inspect(user_id, label: "inspecting the current user")
  case Tasks.create_task(task_params, 7) do
    {:ok, task} ->
      conn
      |> put_status(:ok)
      |> json(%{message: "user's task has been created successfully", task: task})

      {:error, changeset} ->
        conn
        |>put_status(:unprocessable_entity)
        |> json(%{message: "error creating a user's task", errors: changeset.errors})
  end
end

end
