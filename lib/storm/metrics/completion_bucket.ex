defmodule Storm.Metrics.CompletionBucket do
  @moduledoc """
  Agent maintaining the state of the workers processes
  completion callbacks to handle requests metrics.
  """

  @doc """
  Starts a new completion agent
  """
  def start_link do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def pop(key) do
    Agent.get_and_update(__MODULE__, &HashDict.pop(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(key, value) do
    Agent.update(__MODULE__, &HashDict.put(&1, key, value))
  end
end
