defmodule Storm.Mixfile do
  use Mix.Project

  def project do
    [app: :storm,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Storm, []},
      applications: [
        :phoenix, :phoenix_html, :cowboy, :logger, :phoenix_ecto, :postgrex,
        :httpoison, :quantum
      ]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.0"},
     {:phoenix_ecto, "~> 1.2.0"},
     {:phoenix_html, "~> 2.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:joken, "~> 0.15"},
     {:httpoison, "~> 0.7"},
     {:quantum, ">= 1.3.1"},
     {:cors_plug, "~> 0.1.3"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.8", only: :dev}]
  end
end
