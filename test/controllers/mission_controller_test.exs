defmodule Storm.MissionControllerTest do
  use Storm.ConnCase

  alias Storm.Mission

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{name: nil}

  setup do
    user = factory(%Storm.User{}, :insert)
    token = Storm.AuthToken.generate_token(user)
    project = factory(%Storm.Project{user_id: user.id}, :insert)
    mission = factory(%Mission{project_id: project.id}, :insert)

    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token.jwt)

    {:ok, conn: conn, project: project, mission: mission}
  end

  test "lists all entries on index", %{conn: conn, project: p} do
    conn = get conn, project_mission_path(conn, :index, p.id)
    assert [%{}] = json_response(conn, 200)["missions"]
  end

  test "shows chosen resource", %{conn: conn, mission: m} do
    conn = get conn, mission_path(conn, :show, m)
    assert json_response(conn, 200)["mission"] == %{
      "id" => m.id,
      "name" => m.name
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, mission_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, project: p} do
    conn = post conn, project_mission_path(conn, :create, p.id), mission: @valid_attrs
    assert json_response(conn, 201)["mission"]["id"]
    assert Repo.get_by(Mission, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, project: p} do
    conn = post conn, project_mission_path(conn, :create, p.id), mission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, mission: m} do
    conn = put conn, mission_path(conn, :update, m), mission: @valid_attrs
    assert json_response(conn, 200)["mission"]["id"]
    assert Repo.get_by(Mission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, mission: m} do
    conn = put conn, mission_path(conn, :update, m), mission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, mission: m} do
    conn = delete conn, mission_path(conn, :delete, m)
    assert response(conn, 204)
    refute Repo.get(Mission, m.id)
  end
end
