defmodule Winter.AuthTokenTest do
  use Winter.ModelCase
  use Winter.ConnCase

  alias Winter.AuthToken
  alias Winter.User

  test "generate json web token" do
    user = factory :user

    assert %AuthToken{} = AuthToken.generate_token user
  end

  test "authenticate! plug validate auth token" do
    user = factory :user

    token = AuthToken.generate_token user
    conn = conn() |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = AuthToken.authenticate! conn, []
    assert %User{} = conn.assigns[:user]
  end
end
