defmodule Storm.AuthTokenTest do
  use Storm.ModelCase
  use Storm.ConnCase

  alias Storm.AuthToken
  alias Storm.User

  test "generate json web token" do
    user = factory %User{}, :insert

    assert %AuthToken{} = AuthToken.generate_token user
  end

  test "authenticate! plug validate auth token" do
    user = factory %User{}, :insert

    token = AuthToken.generate_token user
    conn = conn() |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = AuthToken.authenticate! conn, []
    assert %User{} = conn.assigns[:user]
  end
end
