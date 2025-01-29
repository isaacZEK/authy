defmodule AuthyWeb.TaskNewLive do
  use AuthyWeb, :live_view
  alias Authy.Tasks
  alias Authy.Task
  alias Authy.Accounts

  # on_mount {TodoAppWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    # current_user = Accounts.get_user!(user_id)

    # case current_user.user_type do
    #   "USER" ->
        task = Tasks.list_tasks(user_id)
        {:ok, assign(socket,user_id: user_id, tasks: task)}

    #   "ADMIN" ->
    #     socket =
    #       socket
    #       |> put_flash(:error, "You do not have permission to view user dashboard")
    #       |> redirect(to: ~p"/admin")
    #       {:ok, socket}
    # end

  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, set_action(socket, socket.assigns.live_action, params)}
  end

  defp set_action(socket, :edit, params) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.list_task!(params["id"]))
  end

  defp set_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp set_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({LiveViewCrudWeb.UserLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, assign(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id
    query = Tasks.list_task!(id)

    case Tasks.soft_delete(query) do
      {:ok, _task} ->
        task = Tasks.list_tasks(user_id)
        socket =
          socket
          |> assign(tasks: task)
          |> put_flash(:info, "Task deleted successfully.")
        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, "Failed to delete task: #{reason}")
        {:noreply, socket}
    end
  end

  def handle_event("complete", %{"id" => id}, socket) do
    query = Tasks.list_task!(id)

    case Tasks.task_completed(query) do
      {:ok, _task} ->
        task = Tasks.list_tasks(id)
        socket =
          socket
          |> assign(tasks: task)
          |> put_flash(:info, "Task Is Marked as Completed")
        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, "Failed to complete task: #{reason}")
        {:noreply, socket}
    end
  end


  def handle_event("undo", %{"id" => id}, socket) do
    query = Tasks.list_task!(id)

    case Tasks.task_undone(query) do
      {:ok, _task} ->
        task = Tasks.list_tasks(id)
        socket =
          socket
          |> assign(tasks: task)
          |> put_flash(:info, "Task has been undone")
          IO.inspect(socket, label: "Show socket information")
        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, "Failed to undo task: #{reason}")
        {:noreply, socket}
    end
  end
end
