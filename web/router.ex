defmodule Winter.Router do
  use Winter.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Winter do
    pipe_through :api
    resources "/auth_token", AuthTokenController, only: [:create]
    resources "/users", UserController
    resources "/projects", ProjectController do
      resources "/missions", MissionController, only: [:index, :create]
    end
    resources "/missions", MissionController, only: [:show, :update, :delete]
    resources "/targets", TargetController
  end
end
