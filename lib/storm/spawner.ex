defmodule Storm.Spawner do

  def run do
    run Repo.all(Storm.Mission)
  end

  def run missions do
    spawn_worker missions, 0
  end

  defp spawn_worker [mission | missions], wc do
    spawn fn -> Storm.Worker.run(mission) end
    spawn_worker missions, wc + 1
  end

  defp spawn_worker [], wc do
    {:ok, workers_count: wc}
  end
end
