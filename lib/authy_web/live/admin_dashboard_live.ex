# lib/your_app_web/live/admin_dashboard_live.ex
defmodule AuthyWeb.AdminDashboardLive do
  use AuthyWeb, :live_view

  alias Authy.Accounts
  alias Authy.Tasks

  @impl true
  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(_params, _session, socket) do
    # Fetch all users
    users = Accounts.list_users()
    {:ok, assign(socket, users: users, user: nil, tasks: [], show_tasks: false)}
  end

  @impl true
  def handle_event("show_tasks", %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    tasks = Tasks.list_tasks(user_id)
    IO.inspect(tasks, label: "task listed")
    {:noreply, assign(socket, show_tasks: true, user: user, tasks: tasks)}
  end

  @impl true
  def handle_event("back_to_dashboard", _params, socket) do
    {:noreply, assign(socket, show_tasks: false, user: nil, tasks: [])}
  end

  @impl true
  def handle_event("delete_user", %{"id" => id}, socket) do
    case Accounts.soft_delete_user(id) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> assign(users: Accounts.list_users())
         |> put_flash(:info, "User deleted successfully")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to delete user: #{inspect(reason)}")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="admin-dashboard py-6 px-8">
      <%= if @show_tasks do %>
        <h1 class="text-3xl font-bold text-center my-6">Tasks for <%= @user.email %></h1>
        <div class="flex justify-center">
          <table class="min-w-full bg-white rounded-lg overflow-hidden shadow-md">
            <thead class="bg-gray-100">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Task</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Description</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <%= for task <- @tasks do %>
                <tr id={"#{task.id}"} class="hover:bg-gray-50 transition duration-150 ease-in-out">
                  <td class="px-6 py-4 text-sm text-gray-900"><%= task.name %></td>
                  <td class="px-6 py-4 text-sm text-gray-900"><%= task.description %></td>
                  <td class="px-6 py-4 text-sm text-gray-900">
                    <%= if task.status == "COMPLETED" do %>
                      <span class="px-2 py-1 text-xs font-semibold leading-5 text-green-800 bg-green-100 rounded-full">COMPLETE</span>
                    <% else %>
                      <span class="px-2 py-1 text-xs font-semibold leading-5 text-red-800 bg-red-100 rounded-full">NOT COMPLETED</span>
                    <% end %>
                  </td>


                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
        <div class="flex justify-center mt-6">
          <.link navigate="/admin"
            class="inline-flex items-center justify-center px-6 py-3 text-lg font-semibold text-white bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full shadow-lg hover:from-indigo-600 hover:to-purple-600 hover:shadow-xl transition duration-300 ease-in-out transform hover:scale-105">
            &#8592; Back to Dashboard
          </.link>
        </div>
      <% else %>
        <h1 class="text-3xl font-bold text-center my-6">Admin Dashboard</h1>
        <div class="flex justify-center">
          <table class="min-w-full bg-white rounded-lg overflow-hidden shadow-md">
            <thead class="bg-gray-100">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date Created</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <%= for user <- @users do %>
                <tr id={"#{user.id}"} class="hover:bg-gray-50 transition duration-150 ease-in-out">
                  <td class="px-6 py-4 text-sm text-gray-900"><%= user.email %></td>
                  <td class="px-6 py-4 text-sm text-gray-900"><%= user.inserted_at %></td>
                  <td class="px-6 py-4 text-sm text-gray-900">
                    <div class="actions flex space-x-2">
                      <button
                        phx-click="show_tasks"
                        phx-value-user_id={user.id}
                        class="button-link view-tasks-link px-4 py-2 text-sm font-medium text-white bg-blue-500 rounded-lg hover:bg-blue-600 transition duration-150 ease-in-out">
                        View Tasks
                      </button>
                      <button
                        phx-click={JS.push("delete_user", value: %{id: user.id}) |> hide("##{user.id}") }
                        phx-value-id={user.id}
                        class="button-link delete-link px-4 py-2 text-sm font-medium text-white bg-red-500 rounded-lg hover:bg-red-600 transition duration-150 ease-in-out">
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      <% end %>
    </div>
    """
  end
end
