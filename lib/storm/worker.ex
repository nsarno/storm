defmodule Storm.Worker do
  @moduledoc """
  Process to execute a mission
  """

  alias Storm.Repo
  import Ecto.Model

  def run mission do
    Enum.map Repo.all(assoc(mission, :targets)), fn t ->
      hit_target t
    end
  end

  defp hit_target %Storm.Target{url: url, method: "GET"} do
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
