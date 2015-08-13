defmodule Storm.Spawner do
  def run do
    spawn_worker Storm.Repo.all(Storm.Mission), 0
  end

  defp spawn_worker [mission | missions], wc do
    spawn fn -> Storm.Worker.run(mission) end
    spawn_worker missions, wc + 1
  end

  defp spawn_worker [], wc do
    {:ok, workers_count: wc}
  end
end
