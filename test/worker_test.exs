defmodule Storm.WorkerTest do
  use ExUnit.Case
  import Storm.Factory

  test "run a mission without targets successfuly" do
    assert Storm.Worker.exec(factory(%Storm.Mission{})) == []
  end

  # Needs to be mocked
  # HTTP requests = slow/unpredictable tests
  # test "run a mission with targets successfuly" do
  #   user = factory %Storm.User{}, :insert
  #   project = factory %Storm.Project{user_id: user.id}, :insert
  #   mission = factory %Storm.Mission{project_id: project.id}, :insert
  #   factory %Storm.Target{mission_id: mission.id}, :insert

  #   assert Storm.Worker.exec(mission) == [:ok]
  # end
end
