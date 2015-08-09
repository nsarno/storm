defmodule Winter.AuthTokenTest do
  use Winter.ModelCase

  alias Winter.AuthToken

  test "generate json web token" do
    user = factory :user
    assert %AuthToken{} = AuthToken.generate_token user
  end

  # test "authenticate! plug validate auth token" do
  #   user = factory :user
  #   token = AuthToken.generate_token user
  #   conn = conn() |> put_req_header("Authorization", "Bearer " <> token.jwt)
  #   {:ok, conn} = AuthToken.authenticate! conn
  # end
end
