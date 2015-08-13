defmodule Storm.SpawnerTest do
  use ExUnit.Case, async: false
  import Storm.Factory

  setup do
    user = factory %Storm.User{}, :insert
    project = factory %Storm.Project{user_id: user.id}, :insert
    on_exit fn -> clean_all end
    {:ok, project: project}
  end

  test "run with no missions" do
    assert {:ok, workers_count: wc} = Storm.Spawner.run
    assert wc == 0
  end

  test "run with a mission", %{project: project} do
    mission = factory %Storm.Mission{project_id: project.id}, :insert
    assert {:ok, workers_count: wc} = Storm.Spawner.run
    assert wc == 1
  end
end
