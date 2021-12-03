defmodule DayThreeSolution do
  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  end

  defp highest(data, i) do
    data
    |> Enum.map(fn x -> Enum.at(x, i) end)
    |> Enum.frequencies()
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(0)
  end

  defp flip("0"), do: "1"
  defp flip("1"), do: "0"

  defp solve(data) do
    iters = length(Enum.at(data, 0))

    highest =
      0..(iters - 1)
      |> Enum.to_list()
      |> Enum.map(fn i -> highest(data, i) end)

    gamma = highest |> Enum.join("") |> Integer.parse(2) |> elem(0)
    epsilon = highest |> Enum.map(&flip/1) |> Enum.join("") |> Integer.parse(2) |> elem(0)

    gamma * epsilon
  end

  def part_one(), do: load_data() |> solve()
end
