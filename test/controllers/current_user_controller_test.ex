defmodule Storm.CurrentUserControllerTest do
  use Storm.ConnCase

  setup do
    user = factory(%Storm.User{}, :insert)
    token = Storm.AuthToken.generate_token(user)

    conn = conn() 
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token.jwt)

    {:ok, conn: conn}
  end

  test "index without a valid token returns not found" do
    conn = conn()
    conn = get conn, current_user_path(conn, :index)
    assert json_response(conn, 401)
  end

  test "index with a valid token returns current authenticated user", %{conn: conn} do
    conn = get conn, current_user_path(conn, :index)
    assert %{"id" => _, "email" => _, "name" => _} = json_response(conn, 200)["current_user"]
  end
end
