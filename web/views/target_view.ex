defmodule Winter.TargetView do
  use Winter.Web, :view

  def render("index.json", %{targets: targets}) do
    %{data: render_many(targets, "target.json")}
  end

  def render("show.json", %{target: target}) do
    %{data: render_one(target, "target.json")}
  end

  def render("target.json", %{target: target}) do
    %{id: target.id, method: target.method, url: target.url}
  end
end
