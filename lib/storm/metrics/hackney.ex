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

  def new(type, name) do
    # IO.puts "NEW #{inspect name}"
    :ok
  end

  def delete(name) do
    # IO.puts "DELETE #{inspect name}"
    :ok
  end

  def increment_counter(name) do
    # IO.puts "INC #{inspect name}"
    :ok
  end

  def increment_counter(name, value) do
    # IO.puts "INC #{inspect name} - #{inspect value}"
    :ok
  end

  def decrement_counter(name) do
    # IO.puts "DEC #{inspect name}"
    :ok
  end

  def decrement_counter(name, value) do
    # IO.puts "DEC #{inspect name} - #{inspect value}"
    :ok
  end

  def update_histogram(name, fun) when is_function(fun) do
    :ok
  end

  def update_histogram([:hackney, host, :response_time], value) do
    IO.puts "(#{inspect(self)}) ---> response_time [#{inspect host}] => #{inspect value}"
    :ok
  end

  def update_histogram(name, value) do
    :ok
  end

  def update_gauge(name, value) do
    # IO.puts "UPDATE GAUGE #{inspect name} - #{inspect value}"
    :ok
  end

  def update_meter(name, value) do
    # IO.puts "UPDATE METER #{inspect name} - #{inspect value}"
    :ok
  end
end
