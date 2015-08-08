defmodule Winter.AuthTokenTest do
  use Winter.ModelCase

  @valid_attrs %{email: "example@mail.com", password: "secret"}
  @invalid_attrs %{}

  test "the truth" do
    assert 1 + 1 == 2
  end
end
