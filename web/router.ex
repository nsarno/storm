defmodule Winter.Router do
  use Winter.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Winter do
    pipe_through :api
    resources "/users", UserController
    resources "/targets", TargetController
  end
end
