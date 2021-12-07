defmodule AdventOfCode.DaySevenSolution do
  defp load_data(),
    do:
      AdventOfCode.load_data(7, "data.txt")
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp solve(data) do
    data
    |> Enum.map(fn pt ->
      total_fuel =
        data
        |> Enum.map(fn other -> abs(other - pt) end)
        |> Enum.sum()

      {pt, total_fuel}
    end)
    |> Enum.min_by(&elem(&1, 1))
  end

  def part_one(), do: load_data() |> solve()
end
