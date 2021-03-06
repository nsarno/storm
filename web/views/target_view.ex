defmodule Storm.TargetView do
  use Storm.Web, :view

  def render("index.json", %{targets: targets}) do
    %{targets: render_many(targets, Storm.TargetView, "target.json")}
  end

  def render("show.json", %{target: target}) do
    %{target: render_one(target, Storm.TargetView, "target.json")}
  end

  def render("target.json", %{target: target}) do
    %{id: target.id, method: target.method, url: target.url}
  end
end
