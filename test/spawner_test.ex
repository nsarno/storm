defmodule Storm.SpawnerTest do
  use ExUnit.Case, async: false
  import Storm.Factory

  setup do
    {:ok, missions: [factory(%Storm.Mission{})]}
  end

  test "run with no missions" do
    assert {:ok, workers_count: wc} = Storm.Spawner.run
    assert wc == 0
  end

  test "run with a mission", %{missions: missions} do
    assert {:ok, workers_count: wc} = Storm.Spawner.run missions
    assert wc == 1
  end
end
