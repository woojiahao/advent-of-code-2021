defmodule AdventOfCode.DaySevenSolution do
  defp load_data(),
    do:
      AdventOfCode.load_data(7, "data.txt")
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp solve(data) do
    {min, max} = data |> Enum.min_max()

    min..max
    |> Enum.map(fn goal ->
      data
      |> Enum.map(fn pt -> abs(goal - pt) end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def part_one(), do: load_data() |> solve()

  defp calculate_expensive_fuel(pt, other) do
    x = abs(pt - other)
    trunc(0.5 * x * x + 0.5 * x)
  end

  defp expensive_solve(data) do
    {min, max} = data |> Enum.min_max()

    min..max
    |> Enum.map(fn goal ->
      data
      |> Enum.map(&calculate_expensive_fuel(&1, goal))
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def part_two(), do: load_data() |> expensive_solve()
end
