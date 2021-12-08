defmodule AdventOfCode.DayEightSolution do
  defp load_data() do
    AdventOfCode.load_data(8, 'data.txt')
    |> Enum.map(&String.split(&1, "|", trim: true))
    |> Enum.map(fn [first, second] ->
      signals = String.split(first)
      output = String.split(second)
      {signals, output}
    end)
  end

  defp solve(data), do: solve(data, 0)

  defp solve([], total), do: total

  defp solve([output | rest], total) do
    c = output |> Enum.count(fn o -> String.length(o) in [2, 3, 4, 7] end)
    solve(rest, total + c)
  end

  def part_one(), do: load_data() |> Enum.map(&elem(&1, 1)) |> solve()
end
