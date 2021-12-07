defmodule AdventOfCode.DaySixSolution do
  defp load_data(),
    do:
      AdventOfCode.load_data(6, "data.txt")
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

  defp set_population({0, count}, acc),
    do:
      acc
      |> Map.update(6, count, &(&1 + count))
      |> Map.update(8, count, &(&1 + count))

  defp set_population({n, count}, acc), do: acc |> Map.update(n - 1, count, &(&1 + count))

  defp solve(fishes, days), do: solve(fishes, 1, days)

  defp solve(fishes, day, days) when day > days, do: fishes |> Map.values() |> Enum.sum()

  defp solve(fishes, day, days) do
    u_fishes = fishes |> Enum.reduce(%{}, &set_population/2)
    solve(u_fishes, day + 1, days)
  end

  def part_one(), do: load_data() |> solve(80)

  def part_two(), do: load_data() |> solve(256)
end
