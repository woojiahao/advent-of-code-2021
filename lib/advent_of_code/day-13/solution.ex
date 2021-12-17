defmodule AdventOfCode.DayThirteenSolution do
  @fold ~r/^fold along (x|y)=(\d+)$/

  defp load_data() do
    [raw_coords, raw_folds] =
      AdventOfCode.load_data(13, "data.txt", true)
      |> String.split("\n\n", trim: true)

    coords =
      raw_coords
      |> String.split(~r/[\n ,]/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)

    folds =
      raw_folds
      |> String.split("\n", trim: true)
      |> Enum.map(fn fold ->
        [_, d, c] = Regex.run(@fold, fold)
        {d, String.to_integer(c)}
      end)

    {coords, folds}
  end

  defp solve([], coords), do: coords

  defp solve([fold | rest], coords) do
    solve(rest, fold(fold, coords))
  end

  defp fold({"x", c}, coords) do
    coords
    |> Enum.filter(fn [x, _] -> x != c end)
    |> Enum.map(fn [x, y] ->
      dist = x - c
      if x < c, do: [x, y], else: [x - dist * 2, y]
    end)
    |> Enum.uniq()
  end

  defp fold({"y", c}, coords) do
    coords
    |> Enum.filter(fn [_, y] -> y != c end)
    |> Enum.map(fn [x, y] ->
      dist = y - c
      if y < c, do: [x, y], else: [x, y - dist * 2]
    end)
    |> Enum.uniq()
  end

  def part_one() do
    {coords, folds} = load_data()
    fold(folds |> Enum.at(0), coords) |> length()
  end

  def part_two() do
    {coords, folds} = load_data()
    folded = solve(folds, coords)
    max_x = Enum.max_by(folded, fn [x, _] -> x end) |> Enum.at(0)
    max_y = Enum.max_by(folded, fn [_, y] -> y end) |> Enum.at(1)

    for x <- 0..max_x do
      for y <- 0..max_y do
        if [x, y] in folded, do: IO.write("*"), else: IO.write(" ")
      end

      IO.puts("")
    end
  end
end
