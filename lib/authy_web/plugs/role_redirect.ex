defmodule AuthyWeb.Plugs.RoleRedirect do
  import Plug.Conn
  import Phoenix.Controller
  alias Authy.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    # Fetch the current user from the session or connection
    user_id = get_session(conn, :user_id)

    if user_id do
      current_user = Accounts.get_user!(user_id)

      # Get the requested path
      requested_path = conn.request_path

      case {current_user.user_type, requested_path} do
        {"ADMIN", "/todo"} ->
          # Redirect admins trying to access the user dashboard
          conn
          |> put_flash(:info, "Admins are redirected to the admin dashboard.")
          |> redirect(to: "/admin")
          |> halt()

        {"USER", "/admin"} ->
          # Redirect regular users trying to access the admin dashboard
          conn
          |> put_flash(:error, "You do not have permission to access this page.")
          |> redirect(to: "/todo")
          |> halt()

        _ ->
          # Allow access for all other cases
          conn
      end
    else
      # Handle case where user is not logged in
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
