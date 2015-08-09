defmodule Winter.AuthTokenControllerTest do
  use Winter.ConnCase

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    factory(:user) |> Repo.insert!

    conn = post conn, auth_token_path(conn, :create), auth_token: attrs(:user)
    assert json_response(conn, 200)["data"]["jwt"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, auth_token_path(conn, :create), auth_token: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end
end
