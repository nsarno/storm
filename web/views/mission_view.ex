defmodule Storm.MissionView do
  use Storm.Web, :view

  def render("index.json", %{missions: missions}) do
    %{missions: render_many(missions, Storm.MissionView, "mission.json")}
  end

  def render("show.json", %{mission: mission}) do
    %{mission: render_one(mission, Storm.MissionView, "mission.json")}
  end

  def render("mission.json", %{mission: mission}) do
    %{id: mission.id, name: mission.name}
  end
end
