defmodule Winter.UserTest do
  use Winter.ModelCase

  alias Winter.User

  @valid_attrs %{email: "example@mail.com", name: "somename", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset generates a password digest" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    assert Map.has_key?(changeset.changes, :password_digest)

    digest = User.digest_password(@valid_attrs.password)
    assert changeset.changes.password_digest == digest
  end

  test "verify password" do
    user = factory(:user) |> Repo.insert!

    refute User.verify_password(user, "invalid")
    assert User.verify_password(user, user.password)
  end

  test "validate password length" do
    attrs = Map.merge @valid_attrs, %{password: String.duplicate("x", 5)}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "validate uniqueness of email" do
    factory(:user) |> Repo.insert!
    changeset = User.changeset(%User{}, attrs(:user))

    refute changeset.valid?
    assert changeset.errors[:email]
  end
end
