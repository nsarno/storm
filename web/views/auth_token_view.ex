defmodule Winter.AuthTokenView do
  use Winter.Web, :view

  def render("show.json", %{auth_token: token}) do
    %{data: render_one(token, Winter.AuthTokenView, "auth_token.json")}
  end

  def render("auth_token.json", %{auth_token: token}) do
    %{jwt: token.jwt}
  end
end
