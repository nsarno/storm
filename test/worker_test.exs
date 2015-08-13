defmodule Storm.WorkerTest do
  use ExUnit.Case
  import Storm.Factory

  setup do
    user = factory %Storm.User{}, :insert
    project = factory %Storm.Project{user_id: user.id}, :insert
    mission = factory %Storm.Mission{project_id: project.id}, :insert
    {:ok, mission: mission}
  end

  test "run a mission without targets successfuly", %{mission: mission} do
    assert Storm.Worker.run(mission) == []
  end

  ## Needs to be mocked
  ## HTTP requests = slow/unpredictable tests
  # test "run a mission with targets successfuly", %{mission: mission} do
  #   factory %Storm.Target{mission_id: mission.id}, :insert
  #   assert Storm.Worker.run(mission) == [:ok]
  # end
end
