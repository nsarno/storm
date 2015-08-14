defmodule Storm.Metrics.Hackney do
  @moduledoc """
    Implement Hackney metrics API.

    ## Configuration

    Hackney has to be configured to use this module.

    ```
    # in file config/config.exs
    config :hackney, mod_metrics: Berserkr.Metrics.Hackney
    ```
  """

  alias Storm.Metrics.CompletionBucket

  def new(_type, _name), do: :ok

  def delete(_name), do: :ok

  def increment_counter(_name), do: :ok

  def increment_counter(_name, _value), do: :ok

  def decrement_counter(_name), do: :ok

  def decrement_counter(_name, _value), do: :ok

  def update_histogram(_name, _fun) when is_function(_fun), do: :ok

  def update_histogram([:hackney, _host, :response_time], value) do
    CompletionBucket.pop(self).(value)
    :ok
  end

  def update_histogram(_name, _value), do: :ok

  def update_gauge(_name, _value), do: :ok

  def update_meter(_name, _value), do: :ok
end
