defmodule AuthyWeb.TaskLive.FormComponent do
  use AuthyWeb, :live_component
  alias Authy.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6 bg-white shadow-md rounded-lg">

      <.header class="text-2xl font-semibold text-gray-800 mb-4">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="mb-4">
          <.input
            field={@form[:name]}
            type="text"
            label="Name"
            class="w-full p-3 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div class="mb-4">
          <.input
            field={@form[:description]}
            type="text"
            label="Description"
            class="w-full p-3 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <:actions>
          <.button
            phx-disable-with="Saving..."
            class="w-full py-2 px-4 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            Save Task
          </.button>
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
     |> assign_new(:form, fn -> to_form(Tasks.change_task(task)) end)}
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
        IO.puts("Scheduling :clear_flash message...") # Debugging
        Process.send_after(self(), :clear_flash, 5000)

        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
    IO.inspect(socket.assigns, label: "checking the socket")
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
