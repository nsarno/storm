defmodule Winter.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Winter.Repo
  alias Winter.User


  def attrs :user do
    %User{
      email: "john@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"
    }
  end

  def factory :user do
    factory :user, attrs(:user)
  end

  def factory :user, %User{} = user do
    Repo.insert! user
  end
end
