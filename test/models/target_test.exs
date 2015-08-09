defmodule Winter.TargetTest do
  use Winter.ModelCase

  alias Winter.Target

  @valid_attrs %{url: "https://gist.github.com/", method: "GET"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Target.changeset(%Target{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Target.changeset(%Target{}, @invalid_attrs)
    refute changeset.valid?
  end
end
