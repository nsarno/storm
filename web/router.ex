defmodule Winter.Router do
  use Winter.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Winter do
    pipe_through :api

 
    resources "/users", UserController, except: [:new, :edit]
    resources "/auth_token", AuthTokenController, only: [:create]
 
    resources "/projects", ProjectController, except: [:new, :edit] do
      resources "/missions", MissionController, only: [:index, :create]
    end

    resources "/missions", MissionController, only: [:show, :update, :delete] do
      resources "/targets", TargetController, only: [:index, :create]
    end

    resources "/targets", TargetController, only: [:show, :update, :delete]
  end
end
