defmodule Storm.SpawnerTest do
  use ExUnit.Case, async: false
  import Storm.Factory

  setup do
    {:ok, missions: [factory(%Storm.Mission{})]}
  end

  test "run with no missions" do
    assert :ok = Storm.Spawner.run
  end

  test "run with a mission", %{missions: missions} do
    assert :ok = Storm.Spawner.run missions
  end
end
