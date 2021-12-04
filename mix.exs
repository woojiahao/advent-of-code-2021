defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "1.0.0",
      elixir: "~> 1.12",
      deps: deps()
    ]
  end

  def deps do
    [
      {:matrex, "~> 0.6"},
      {:benchee, "~> 1.0"}
    ]
  end
end
