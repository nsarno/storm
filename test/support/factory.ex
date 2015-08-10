defmodule Winter.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Winter.User
  alias Winter.Project
  alias Winter.Target

  def attrs %Winter.User{} do
    %{email: uniq <> "@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"}
  end

  def attrs %Winter.Project{} do
    %{name: "blairwitch"}
  end

  def attrs %Winter.Target{} do
    %{url: "https://github.com/", method: "GET"}
  end

  def factory model do
    Map.merge model, attrs(model)
  end

  def factory model, :insert do
    factory(model) |> Winter.Repo.insert!
  end

  defp uniq do
    {me, s, mi} = :os.timestamp
    to_string(me + s + mi)
  end
end
