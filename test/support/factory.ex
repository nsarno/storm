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
    %{name: "project_name"}
  end

  def attrs %Storm.Mission{} do
    %{name: "mission_name"}
  end

  def attrs %Storm.Target{} do
    %{url: "https://github.com/", method: "GET"}
  end

  def factory model do
    Map.merge attrs(model), model, fn _k, v1, v2 ->
      if is_nil(v2), do: v1, else: v2
    end
  end

  def factory model, :insert do
    factory(model) |> Storm.Repo.insert!
  end

  def clean_all do
    Storm.Repo.delete_all(Storm.Target)
    Storm.Repo.delete_all(Storm.Mission)
    Storm.Repo.delete_all(Storm.Project)
    Storm.Repo.delete_all(Storm.User)
  end

  defp uniq do
    {me, s, mi} = :os.timestamp
    to_string(me + s + mi)
  end
end
