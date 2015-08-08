defmodule Winter.AuthTokenController do
  use Winter.Web, :controller

  alias Winter.AuthToken
  alias Winter.User

  require Logger

  plug :scrub_params, "auth_token" when action in [:create]

  def create conn, %{"auth_token" => auth_params} do
    case AuthToken.validate_params(auth_params) do
      {:ok, email: email, password: password} ->
        user = User.authenticate!(email, password)
        render(conn, "show.json", auth_token: AuthToken.generate_token user)
      {:error, changeset: changeset} ->
        render(Winter.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
