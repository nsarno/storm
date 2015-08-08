defmodule Winter.AuthTokenControllerTest do
  use Winter.ConnCase

  alias Winter.User

  @valid_attrs %{email: "john@example.com", name: "john", password: "secret"}
  @invalid_attrs %{}

  setup do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)
    {:ok, user: user}
  end

  test "creates and renders resource when data is valid", %{user: user} do
    conn = post conn, auth_token_path(conn, :create), auth_token: %{
      email: user.email, password: user.password
    }
    assert json_response(conn, 200)["data"]["jwt"]
  end
end
