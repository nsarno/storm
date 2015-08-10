defmodule Winter.MissionView do
  use Winter.Web, :view

  def render("index.json", %{missions: missions}) do
    %{data: render_many(missions, Winter.MissionView, "mission.json")}
  end

  def render("show.json", %{mission: mission}) do
    %{data: render_one(mission, Winter.MissionView, "mission.json")}
  end

  def render("mission.json", %{mission: mission}) do
    %{id: mission.id, name: mission.name}
  end
end
