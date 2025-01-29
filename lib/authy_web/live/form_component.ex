defmodule AuthyWeb.TaskLive.FormComponent do
  use AuthyWeb, :live_component
  alias Authy.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="description" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>

      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{task: task} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tasks.change_task(task))
     end)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = Tasks.change_task(socket.assigns.task, task_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    task = socket.assigns.id
    task_map = Tasks.list_task!(task)

   case Tasks.update_task(task_map, task_params) do
    {:ok, _task} ->
      {:noreply,
      socket
      |> put_flash(:info, "Task updated successfully")
      |> push_navigate(to: socket.assigns.patch)}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
     case Tasks.create_task(task_params, socket.assigns.user.id) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
