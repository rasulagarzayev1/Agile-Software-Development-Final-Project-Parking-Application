defmodule AgileparkingWeb.Router do
  use AgileparkingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug Agileparking.Authentication, repo: Agileparking.Repo
  end

  pipeline :browser_auth do
    plug Agileparking.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", AgileparkingWeb do
    pipe_through [:browser]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:new, :create]
  end

  scope "/", AgileparkingWeb do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
  end

  scope "/", AgileparkingWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]
    resources "/zones", ZoneController
    resources "/users", UserController
    resources "/cards", CardController
  end
  scope "/", AgileparkingWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]
    resources "/bookings", BookingController
    resources "/users", UserController
  end



  # Other scopes may use custom stacks.
  # scope "/api", AgileparkingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AgileparkingWeb.Telemetry
    end
  end
end
