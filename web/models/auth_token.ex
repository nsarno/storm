defmodule Winter.AuthToken do
  defstruct jwt: nil

  alias Winter.AuthToken
  alias Winter.User

  def generate_token %User{id: id} do
    {:ok, token} = Joken.encode %{sub: id}
    %AuthToken{jwt: token}
  end

  # def authenticate! conn do
  #   conn
  # end
end
