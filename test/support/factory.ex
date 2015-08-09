defmodule Winter.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Winter.User
  alias Winter.Target

  def factory :user do
    %User{email: "john@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"}
  end

  def factory :target do
    %Target{url: "https://github.com/", method: "GET"}
  end

  def attrs m do
    Map.delete(factory(m), :__struct__)
  end
end
