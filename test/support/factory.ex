defmodule Winter.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Winter.User
  alias Winter.Project
  alias Winter.Target

  def factory :user do
    %User{
      email: ts <> "@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"
    }
  end

  def factory :project, %User{id: user_id} do
    %Project{
      name: "blairwitch",
      user_id: user_id,
    }
  end

  def factory :project do
    factory :project, factory(:user, :insert)
  end

  def factory :target do
    %Target{url: "https://github.com/", method: "GET"}
  end

  def factory m, :insert do
    factory(m) |> Winter.Repo.insert!
  end

  def factory m, opts, :insert do
    factory(m, opts) |> Winter.Repo.insert!
  end

  def attrs m do
    Map.delete(factory(m), :__struct__) |> Map.delete(:__meta__)
  end

  def attrs m, opts do
    Map.delete(factory(m, opts), :__struct__) |> Map.delete(:__meta__)
  end

  defp ts do
    {ms, s, _} = :os.timestamp
    to_string(ms * 1_000_000 + s)
  end
end
