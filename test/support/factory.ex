defmodule Winter.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Winter.Repo
  alias Winter.User
  alias Winter.Target

  def attrs :user do
    %{
      email: "john@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"
    }
  end

  def attrs :target do
    %{url: "https://github.com/", method: "GET"}
  end

  def factory :user do
    factory :user, attrs(:user)
  end

  def factory :target do
    factory :target, attrs(:target)
  end

  def factory :user, %{} = user do
    Repo.insert! Map.merge(%User{}, user)
  end

  def factory :target, %{} = target do
    Repo.insert! Map.merge(%Target{}, target)
  end
end
