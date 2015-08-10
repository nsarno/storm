defmodule Storm.Factory do
  @moduledoc """
    Provides helper functions to easily run test against persisted data.
  """

  alias Storm.User
  alias Storm.Project
  alias Storm.Target

  def attrs %Storm.User{} do
    %{email: uniq <> "@example.com",
      name: "john",
      password: "secret",
      password_digest: User.digest_password "secret"}
  end

  def attrs %Storm.Project{} do
    %{name: "blairwitch"}
  end

  def attrs %Storm.Mission{} do
    %{name: "impossible"}
  end

  def attrs %Storm.Target{} do
    %{url: "https://github.com/", method: "GET"}
  end

  def factory model do
    Map.merge model, attrs(model)
  end

  def factory model, :insert do
    factory(model) |> Storm.Repo.insert!
  end

  defp uniq do
    {me, s, mi} = :os.timestamp
    to_string(me + s + mi)
  end
end
