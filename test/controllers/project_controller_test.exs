defmodule Storm.ProjectControllerTest do
  use Storm.ConnCase

  alias Storm.Project

  @valid_attrs %{name: "some project"}
  @invalid_attrs %{name: nil}

  setup do
    user = factory(%Storm.User{}, :insert)
    token = Storm.AuthToken.generate_token(user)
    project = factory(%Project{user_id: user.id}, :insert)
    mission = factory(%Storm.Mission{project_id: project.id}, :insert)

    conn = conn() 
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token.jwt)

    {:ok, conn: conn, project: project}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert [%{}] = json_response(conn, 200)["projects"]
  end

  test "shows chosen resource", %{conn: conn, project: project} do
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200)["project"] == %{
      "id" => project.id,
      "name" => project.name
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["project"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, project: project} do
    conn = put conn, project_path(conn, :update, project), project: @valid_attrs
    assert json_response(conn, 200)["project"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, project: project} do
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, project: project} do
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
