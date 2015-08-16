defmodule Storm.CurrentUserController do
  use Storm.Web, :controller

  plug :authenticate!

  def index(conn, _params) do
    render(conn, "index.json", current_user: conn.assigns[:user])
  end
end