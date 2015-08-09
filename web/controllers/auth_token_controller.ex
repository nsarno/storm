defmodule Winter.AuthTokenController do
  use Winter.Web, :controller

  alias Winter.AuthToken
  alias Winter.User

  plug :scrub_params, "auth_token"
  plug :filter_params
  plug :find_user
  plug :sign_in

  def create conn, _ do
    render(conn, "show.json", auth_token: conn.assigns[:token])
  end

  defp filter_params conn, [] do
    case conn.params["auth_token"] do
      %{"email" => email, "password" => pwd} when not is_nil(email) and not is_nil(pwd) ->
        conn
        |> assign(:email, email)
        |> assign(:password, pwd)
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Winter.ChangesetView, "error.json", reason: "Missing email and/or password")
        |> halt
    end
  end

  defp find_user conn, _ do
    case Repo.get_by User, %{email: conn.assigns[:email]} do
      %User{} = user ->
        assign(conn, :user, user)
      _ ->
        conn
        |> put_status(:not_found)
        |> render(Winter.ChangesetView, "error.json", reason: "Invalid credentials")
        |> halt
    end
  end

  defp sign_in conn, _ do
    if User.verify_password conn.assigns[:user], conn.assigns[:password] do
      assign conn, :token, AuthToken.generate_token(conn.assigns[:user])
    else
      conn
      |> put_status(:not_found)
      |> render(Winter.ChangesetView, "error.json", reason: "Invalid credentials")
      |> halt
    end
  end
end
