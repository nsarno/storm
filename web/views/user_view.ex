defmodule Storm.UserView do
  use Storm.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Storm.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Storm.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
  end
end
