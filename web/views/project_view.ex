defmodule Storm.ProjectView do
  use Storm.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, Storm.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, Storm.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id}
  end
end
