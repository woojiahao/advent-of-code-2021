defmodule DayOneSolution do
  defp get_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp sum_of(data) do
    data
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
  end

  defp solve(data) do
    min = data |> Enum.min()

    [min + 1 | data]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end

  def part_one(), do: get_data() |> solve()
  def part_two(), do: get_data() |> sum_of() |> solve()
end
