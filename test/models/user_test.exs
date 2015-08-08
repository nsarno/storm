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
    import Plug.Crypto.KeyGenerator, only: [generate: 2]
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    assert Map.has_key?(changeset.changes, :password_digest)

    digest = to_hex generate(@valid_attrs.password, Winter.Endpoint.config :secret_key_base)
    assert changeset.changes.password_digest == digest
  end

  test "find by email with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)

    %Winter.User{} = User.find_by_email @valid_attrs.email

    _ = Repo.delete user
  end

  test "find by email with invalid attributes" do
    nil = User.find_by_email @valid_attrs.email
  end

  test "validates email/password combination" do
    nil = User.authenticate @valid_attrs.email, @valid_attrs.password

    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)

    %Winter.User{} = User.authenticate @valid_attrs.email, @valid_attrs.password

    _ = Repo.delete user
  end

  defp to_hex(value), do: Base.encode16(value, case: :lower)
end
