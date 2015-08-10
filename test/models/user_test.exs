defmodule Storm.UserTest do
  use Storm.ModelCase

  alias Storm.User

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, attrs(%User{}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "changeset generates a password digest" do
    user_attrs = attrs(%User{})
    changeset = User.changeset(%User{}, user_attrs)

    assert changeset.valid?
    assert Map.has_key?(changeset.changes, :password_digest)

    digest = User.digest_password(user_attrs.password)
    assert changeset.changes.password_digest == digest
  end

  test "verify password" do
    user = factory(%User{}, :insert)

    refute User.verify_password(user, "invalid")
    assert User.verify_password(user, user.password)
  end

  test "validate password length" do
    too_short = String.duplicate("x", 5)
    invalid_attrs = Map.merge attrs(%User{}), %{password: too_short}
    changeset = User.changeset(%User{}, invalid_attrs)

    refute changeset.valid?
  end

  test "validate uniqueness of email" do
    user = factory(%User{}, :insert)
    changeset = User.changeset(%User{}, Map.from_struct(user))

    refute changeset.valid?
    assert changeset.errors[:email]
  end
end
