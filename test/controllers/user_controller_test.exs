defmodule Storm.UserControllerTest do
  use Storm.ConnCase

  alias Storm.User
  alias Storm.AuthToken

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["users"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = factory(%User{}, :insert)
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["user"] == %{
      "id" => user.id,
      "name" => user.name,
      "email" => user.email
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    valid_attrs = attrs(%User{})
    conn = post conn, user_path(conn, :create), user: valid_attrs
    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, Map.delete(valid_attrs, :password))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "authenticate before user update", %{conn: conn} do
    user = factory(%User{}, :insert)
    valid_attrs = %{name: "John Better"}

    conn = put conn, user_path(conn, :update, user), user: valid_attrs
    assert json_response(conn, 401)
    refute Repo.get_by(User, valid_attrs  )
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = factory(%User{}, :insert)
    valid_attrs = %{name: "John Better", password: user.password}

    token = AuthToken.generate_token user
    conn = conn |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = put conn, user_path(conn, :update, user), user: valid_attrs
    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, Map.delete(valid_attrs, :password))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = factory(%User{}, :insert)

    token = AuthToken.generate_token user
    conn = conn |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = put conn, user_path(conn, :update, user), user: %{name: nil}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = factory(%User{}, :insert)
    conn = delete conn, user_path(conn, :delete, user)

    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
