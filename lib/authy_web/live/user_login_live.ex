defmodule AuthyWeb.UserLoginLive do
  use AuthyWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="mx-auto max-w-md w-full p-8 bg-white rounded-lg shadow-md">
        <div class="text-center mb-6">
          <h1 class="text-2xl font-semibold text-gray-800">Log in to your account</h1>
          <p class="mt-2 text-sm text-gray-600">
            Don't have an account?
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </p>
        </div>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <div class="mb-4">
            <.input field={@form[:email]} type="email" label="Email" required class="block w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand" />
          </div>

          <div class="mb-4">
            <.input field={@form[:password]} type="password" label="Password" required class="block w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand" />
          </div>

          <div class="flex items-center justify-between mb-6">
            <div class="flex items-center">
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" class="h-4 w-4 text-brand focus:ring-brand" />
            </div>
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-brand hover:underline">
              Forgot your password?
            </.link>
          </div>

          <div>
            <.button phx-disable-with="Logging in..." class="w-full py-3 px-4 bg-brand text-white font-semibold rounded-md shadow-md hover:bg-brand-dark focus:outline-none focus:ring-2 focus:ring-brand">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </div>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
