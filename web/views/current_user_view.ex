defmodule Storm.CurrentUserView do
  use Storm.Web, :view

  def render("index.json", %{current_user: current_user}) do
    %{current_user: render_one(current_user, Storm.UserView, "user.json")}
  end
end
