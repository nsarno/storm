defmodule Winter.ProjectTest do
  use Winter.ModelCase

  alias Winter.Project

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, attrs(%Project{}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, %{})
    refute changeset.valid?
  end
end
