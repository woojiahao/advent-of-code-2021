defmodule DayThreeSolution do
  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  end

  defp common(data, i, sorter \\ fn a, b -> a >= b end) do
    data
    |> Enum.frequencies_by(fn x -> Enum.at(x, i) end)
    |> Enum.max_by(fn {_, v} -> v end, sorter)
    |> elem(0)
  end

  defp flip("0"), do: "1"
  defp flip("1"), do: "0"

  defp to_integer(binary_string),
    do: binary_string |> Enum.join("") |> Integer.parse(2) |> elem(0)

  defp solve(data) do
    iters = length(Enum.at(data, 0))

    highest =
      0..(iters - 1)
      |> Enum.to_list()
      |> Enum.map(fn i -> common(data, i) end)

    gamma = highest |> to_integer()
    epsilon = highest |> Enum.map(&flip/1) |> to_integer()

    gamma * epsilon
  end

  defp oxygen(data), do: oxygen(data, 0)

  defp oxygen([last], _), do: last |> to_integer()

  defp oxygen(data, i) do
    highest = data |> common(i, fn a, b -> a > b end)
    filtered = data |> Enum.filter(fn x -> Enum.at(x, i) == highest end)
    oxygen(filtered, i + 1)
  end

  defp carbon_dioxide(data), do: carbon_dioxide(data, 0)

  defp carbon_dioxide([last], _), do: last |> to_integer()

  defp carbon_dioxide(data, i) do
    lowest = data |> common(i, fn a, b -> b >= a end)
    filtered = data |> Enum.filter(fn x -> Enum.at(x, i) == lowest end)
    carbon_dioxide(filtered, i + 1)
  end

  defp solve_two(data) do
    o = oxygen(data, 0)
    co = carbon_dioxide(data, 0)
    oxygen(data) * carbon_dioxide(data)
  end

  def part_one(), do: load_data() |> solve()
  def part_two(), do: load_data() |> solve_two()
end
