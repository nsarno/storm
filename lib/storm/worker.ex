defmodule Storm.Worker do
  @moduledoc """
  Process to execute a mission
  """

  alias Storm.Repo
  alias Storm.Metrics.CompletionBucket
  import Ecto.Model

  def exec mission do
    exec_fork Repo.all(assoc(mission, :targets)), mission.load
  end

  def exec_fork targets, 1 do
    exec_once targets
  end

  def exec_fork targets, n do
    spawn fn -> exec_fork(targets, n - 1) end
    exec_once targets
  end

  defp exec_once targets do
    Enum.map targets, fn t ->
      hit_target t
    end
  end

  defp hit_target %Storm.Target{url: url, method: "GET"} do
    CompletionBucket.put self, &(IO.puts("GET #{url} --> response time: [#{&1}]"))
    log_response url, HTTPoison.get(url)
  end

  defp hit_target %Storm.Target{url: url, method: "POST"} do
    log_response url, HTTPoison.post(url)
  end

  defp log_response url, {:ok, %HTTPoison.Response{status_code: code}} do
    IO.puts "---> [success] hit (#{url}) => #{code}"
  end

  defp log_response url, {:error, %HTTPoison.Response{status_code: code}} do
    IO.puts "---> [error] hit (#{url}) => #{code}"
  end
end
