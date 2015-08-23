defmodule Storm.ProjectView do
  use Storm.Web, :view

  def render("index.json", %{projects: projects}) do
    %{projects: render_many(projects, Storm.ProjectView, "project_with_missions.json")}
  end

  def render("show.json", %{project: project}) do
    %{project: render_one(project, Storm.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id, name: project.name}
  end

  def render("project_with_missions.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      missions: render_many(project.missions, Storm.MissionView, "mission.json")
    }
  end
end
