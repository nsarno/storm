defmodule Storm.AuthTokenView do
  use Storm.Web, :view

  def render("show.json", %{auth_token: token}) do
    %{auth_token: render_one(token, Storm.AuthTokenView, "auth_token.json")}
  end

  def render("auth_token.json", %{auth_token: token}) do
    %{token: token.jwt}
  end
end
