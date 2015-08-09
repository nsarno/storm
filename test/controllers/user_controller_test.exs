defmodule Winter.UserControllerTest do
  use Winter.ConnCase

  alias Winter.User
  alias Winter.AuthToken

  @valid_attrs %{email: "john@example.com", name: "john", password: "secret"}
  @valid_fields Map.delete(@valid_attrs, :password)
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
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
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_fields)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "authenticate before user update", %{conn: conn} do
    user = factory :user
    updated_fields = %{name: "John Better"}

    conn = put conn, user_path(conn, :update, user), user: updated_fields
    assert json_response(conn, 401)
    refute Repo.get_by(User, updated_fields)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = factory :user
    token = AuthToken.generate_token user
    conn = conn |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_fields)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = factory :user
    token = AuthToken.generate_token user
    conn = conn |> put_req_header("authorization", "Bearer " <> token.jwt)

    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = factory :user
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
