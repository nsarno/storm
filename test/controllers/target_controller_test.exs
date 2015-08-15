defmodule Storm.TargetControllerTest do
  use Storm.ConnCase

  alias Storm.Target
  @valid_attrs %{url: "https://gist.github.com/", method: "GET"}
  @invalid_attrs %{url: nil, method: nil}

  setup do
    user = factory(%Storm.User{}, :insert)
    token = Storm.AuthToken.generate_token(user)
    project = factory(%Storm.Project{user_id: user.id}, :insert)
    mission = factory(%Storm.Mission{project_id: project.id}, :insert)
    target = factory(%Target{mission_id: mission.id}, :insert)

    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token.jwt)

    {:ok, conn: conn, mission: mission, target: target}
  end

  test "lists all entries on index", %{conn: conn, mission: m} do
    conn = get conn, mission_target_path(conn, :index, m)
    assert [%{}] = json_response(conn, 200)["targets"]
  end

  test "shows chosen resource", %{conn: conn, target: t} do
    conn = get conn, target_path(conn, :show, t)
    assert json_response(conn, 200)["target"] == %{
      "id" => t.id,
      "method" => t.method,
      "url" => t.url
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, target_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, mission: m} do
    conn = post conn, mission_target_path(conn, :create, m.id), target: @valid_attrs
    assert json_response(conn, 200)["target"]["id"]
    assert Repo.get_by(Target, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, mission: m} do
    conn = post conn, mission_target_path(conn, :create, m.id), target: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, target: t} do
    conn = put conn, target_path(conn, :update, t), target: @valid_attrs
    assert json_response(conn, 200)["target"]["id"]
    assert Repo.get_by(Target, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, target: t} do
    conn = put conn, target_path(conn, :update, t), target: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, target: t} do
    conn = delete conn, target_path(conn, :delete, t)
    assert response(conn, 204)
    refute Repo.get(Target, t.id)
  end
end
