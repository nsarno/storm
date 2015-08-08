defmodule Winter.AuthToken do
  defstruct jwt: nil

  alias Winter.AuthToken
  alias Winter.User

  def validate_params auth_params do
    case auth_params do
      %{"email" => email, "password" => password} ->
        {:ok, email: email, password: password}
      _ ->
        {:error, changeset: "Missing email and/or password"}
    end
  end

  def generate_token %User{id: id} do
    {:ok, token} = Joken.encode(%{sub: id})
    %AuthToken{jwt: token}
  end
end
