defmodule AuthyWeb.Router do
  use AuthyWeb, :router

  import AuthyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuthyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # pipeline :api_auth do

  #   plug Guardian.Plug.Pipeline,
  #     module: AuthyWeb.Guardian,
  #     error_handler: AuthyWebAuthErrorHandler

  #     plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  #     plug Guardian.Plug.EnsureAuthenticated
  #     # plug.Guardian.Plug.LoadResource

  # end

  pipeline :role_redirect do
    plug AuthyWeb.Plugs.RoleRedirect
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", AuthyWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", UserLoginLive, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:authy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuthyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", AuthyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{AuthyWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/api", AuthyWeb.API do
    pipe_through [:api, AuthyWeb.Plugs.AuthPlug]

    post "/login", AuthController, :login
    get "/me", AuthContolller, :me

  end




  scope "/api", AuthyWeb do
    pipe_through [:api]
    post "/task/create", ApiController, :create
    get "/task/showall/", ApiController, :index
    get "/task/show/:id", ApiController, :show
    patch "/task/edit/:id", ApiController, :update
    delete "/task/delete/:id", ApiController, :delete

    post "/taskuser/login", ApiController, :login
    post "/taskuser/create", ApiController, :create_user_task
  end

  # scope "/auth/api", AuthyWeb do
  #   pipe_through :api
  #   post "/login", ApiAuthController, :login
  #   scope "/" do
  #     pipe_through :api_auth
  #     get "/profile", ApiUserController, :profile
  #   end
  # end


  scope "/", AuthyWeb do
    pipe_through [:browser, :require_authenticated_user, :role_redirect]

    live_session :require_authenticated_user, on_mount: [{AuthyWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/todo", TaskNewLive, :index
      live "/todo/new",TaskNewLive, :new
      live "/todo/:id/edit", TaskNewLive,:edit
      live "/admin", AdminDashboardLive, :index
    end
  end

  scope "/", AuthyWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{AuthyWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
