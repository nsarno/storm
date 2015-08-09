defmodule Winter.ProjectView do
  use Winter.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, Winter.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, Winter.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id}
  end
end
