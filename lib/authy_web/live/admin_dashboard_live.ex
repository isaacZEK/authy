# lib/your_app_web/live/admin_dashboard_live.ex
defmodule AuthyWeb.AdminDashboardLive do
  use AuthyWeb, :live_view

  alias Authy.Accounts
  alias Authy.Tasks

  @impl true
  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(_params,_session , socket) do
    # current_user = Accounts.get_user!(user_id)
    # case current_user.user_type do
    #   "ADMIN" ->
        users = Accounts.list_users()
        {:ok, assign(socket, users: users, user: nil, tasks: [], show_tasks: false)}

        # "USER" ->
        #   socket =
        #     socket
        #     |>put_flash(:error, "You do not have permission to access the admin dashboard.")
        #     |> redirect(to: ~p"/todo")
        # {:ok, socket}
      # end




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
    <div class="admin-dashboard">
      <%= if @show_tasks do %>
        <h1><center><b>Tasks for <%= @user.email %></b></center></h1>
        <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <%= for task <- @tasks do %>
            <tr>
              <td><%= task.name %></td>
              <td><%= task.description %></td>
              <td><%= task.status %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
        <button phx-click="back_to_dashboard" class="button-link">Back to Dashboard</button>
      <% else %>
        <h1>Admin Dashboard</h1>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Email</th>
              <th>Date Created</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%= for user <- @users do %>
              <tr>
                <td><%= user.email %></td>
                <td><%= user.inserted_at %></td>
                <td class="actions">
                  <button
                    phx-click="show_tasks"
                    phx-value-user_id={user.id}
                    class="button-link view-tasks-link">
                    View Tasks
                  </button>
                  <button
                    phx-click={JS.push("delete_user", value: %{id: user.id}) |> hide("##{user.id}")}
                    phx-value-id={user.id}
                    class="button-link delete-link">
                    Delete
                  </button>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end
end
