defmodule Winter.ProjectControllerTest do
  use Winter.ConnCase

  alias Winter.Project
  alias Winter.AuthToken

  @valid_attrs %{name: "some project"}
  @invalid_attrs %{}

  setup do
    user = factory(:user, :insert)
    token = AuthToken.generate_token user
    conn = conn() 
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> token.jwt)
    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    project = factory(:project, user, :insert)
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200)["data"] == %{
      "id" => project.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, project_path(conn, :create), project: @valid_attrs
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Project, @valid_attrs)
  # end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   project = factory(:project, :insert)
  #   conn = put conn, project_path(conn, :update, project), project: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(Project, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   project = factory(:project, :insert)
  #   conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "deletes chosen resource", %{conn: conn, user: user} do
    project = factory(:project, user, :insert)
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
