defmodule Winter.TargetControllerTest do
  use Winter.ConnCase

  alias Winter.Target
  @valid_attrs %{url: "https://gist.github.com/", method: "GET"}
  @invalid_attrs %{url: nil, method: nil}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, target_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    target = factory(%Target{}, :insert)
    conn = get conn, target_path(conn, :show, target)
    assert json_response(conn, 200)["data"] == %{
      "id" => target.id,
      "method" => target.method,
      "url" => target.url
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, target_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, target_path(conn, :create), target: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Target, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, target_path(conn, :create), target: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    target = factory(%Target{}, :insert)
    conn = put conn, target_path(conn, :update, target), target: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Target, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    target = factory(%Target{}, :insert)
    conn = put conn, target_path(conn, :update, target), target: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    target = factory(%Target{}, :insert)
    conn = delete conn, target_path(conn, :delete, target)
    assert response(conn, 204)
    refute Repo.get(Target, target.id)
  end
end
