defmodule Storm.Spawner do

  def run do
    run Storm.Repo.all(Storm.Mission)
  end

  def run missions do
    spawn_worker missions
  end

  defp spawn_worker [mission | missions] do
    spawn fn -> Storm.Worker.exec(mission) end
    spawn_worker missions
  end

  defp spawn_worker [] do
    :ok
  end
end
