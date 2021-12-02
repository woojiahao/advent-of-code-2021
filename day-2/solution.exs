defmodule DayTwoSolution do
  defp get_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction -> String.split(instruction, " ") end)
    |> Enum.map(fn [instruction, value] -> [instruction, String.to_integer(value)] end)
  end

  defp solve([["forward", value] | rest], {x, y}), do: solve(rest, {x + value, y})
  defp solve([["up", value] | rest], {x, y}), do: solve(rest, {x, y - value})
  defp solve([["down", value] | rest], {x, y}), do: solve(rest, {x, y + value})
  defp solve([], {x, y}), do: x * y

  defp solve([["forward", value] | rest], {x, y, a}),
    do: solve(rest, {x + value, y + a * value, a})

  defp solve([["up", value] | rest], {x, y, a}), do: solve(rest, {x, y, a - value})
  defp solve([["down", value] | rest], {x, y, a}), do: solve(rest, {x, y, a + value})
  defp solve([], {x, y, _}), do: x * y

  def part_one(), do: get_data() |> solve({0, 0})
  def part_two(), do: get_data() |> solve({0, 0, 0})
end
