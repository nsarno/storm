defmodule Winter.MissionTest do
  use Winter.ModelCase

  alias Winter.Mission

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Mission.changeset(%Mission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Mission.changeset(%Mission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
