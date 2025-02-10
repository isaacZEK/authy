defmodule AuthyWeb.UserRegistrationLive do
  use AuthyWeb, :live_view

  alias Authy.Accounts
  alias Authy.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="mx-auto max-w-md w-full p-8 bg-white rounded-lg shadow-md">
        <div class="text-center mb-6">
          <h1 class="text-2xl font-semibold text-gray-800">Register for an account</h1>
          <p class="mt-2 text-sm text-gray-600">
            Already registered?
            <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
              Log in
            </.link>
            to your account now.
          </p>
        </div>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors} class="mb-4 text-red-500">
            Oops, something went wrong! Please check the errors below.
          </.error>

          <div class="mb-4">
            <.input field={@form[:email]} type="email" label="Email" required class="block w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand" />
          </div>

          <div class="mb-4">
            <.input field={@form[:password]} type="password" label="Password" required class="block w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-brand" />
          </div>

          <div>
            <.button phx-disable-with="Creating account..." class="w-full py-3 px-4 bg-brand text-white font-semibold rounded-md shadow-md hover:bg-brand-dark focus:outline-none focus:ring-2 focus:ring-brand">
              Create an account
            </.button>
          </div>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
