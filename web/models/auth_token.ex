defmodule Storm.AuthToken do
  defstruct jwt: nil

  alias Storm.AuthToken
  alias Storm.User
  alias Storm.Repo

  @doc """
    Plug for JWT authentication.
  """
  def authenticate! conn, _ do
    import Plug.Conn, only: [get_req_header: 2, assign: 3, put_status: 2, halt: 1]
    import Phoenix.Controller, only: [render: 3]

    case decode_token to_string(get_req_header(conn, "authorization")) do
      {:ok, payload} ->
        conn
        |> assign(:user, Repo.get!(User, payload["sub"]))
      {:error, _message} ->
        conn
        |> put_status(:unauthorized)
        |> render(Storm.ErrorView, "401.json")
        |> halt
    end
  end

  @doc """
    Decode a Json Web Token.

    Returns {:ok | :error, payload | :invalid_token}
  """
  def decode_token("Bearer " <> jwt) do
    {:ok, _payload} = Joken.decode jwt
  end

  def decode_token _token do
    {:error, :invalid_token}
  end

  @doc """
    Generate a Json Web Token.
  """
  def generate_token %User{id: id} do
    {:ok, token} = Joken.encode %{sub: id}
    %AuthToken{jwt: token}
  end
end
