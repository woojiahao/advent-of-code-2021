defmodule AdventOfCode.DayFiveSolution do
  defp load_data() do
    AdventOfCode.load_data(5, "data.txt")
    |> Enum.map(&String.replace(&1, " -> ", ","))
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end

  defp gen_coords(x_from, y_from, x_to, y_to) when x_from == x_to do
    0..abs(y_from - y_to)
    |> Enum.map(fn n -> {x_from, y_from + n} end)
  end

  defp gen_coords(x_from, y_from, x_to, y_to) when y_from == y_to do
    0..abs(x_from - x_to)
    |> Enum.map(fn n -> {x_from + n, y_from} end)
  end

  defp gen_coords(x_from, y_from, x_to, y_to) do
    m = get_gradient(x_from, y_from, x_to, y_to)
    {x_start, y_start} = if x_from < x_to, do: {x_from, y_from}, else: {x_to, y_to}

    0..abs(x_from - x_to)
    |> Enum.map(fn n -> {x_start + n, y_start + m * n} end)
  end

  defp get_gradient(x_from, _, x_to, _) when x_from == x_to, do: 0

  defp get_gradient(x_from, y_from, x_to, y_to),
    do: trunc((y_to - y_from) / (x_to - x_from))

  defp solve(data, coords, include_diagonal? \\ false)

  defp solve([], coords, _),
    do: coords |> Enum.frequencies() |> Enum.filter(&(elem(&1, 1) > 1)) |> length()

  defp solve([[[x_from, y_from], [x_to, y_to]] | rest], coords, include_diagonal?) do
    is_horizontal? = x_from == x_to
    is_vertical? = y_from == y_to
    is_straight? = is_horizontal? or is_vertical?
    is_diagonal? = abs(get_gradient(x_from, y_from, x_to, y_to)) == 1

    path_coords =
      if (!is_diagonal? and !is_straight?) or (!include_diagonal? and is_diagonal?),
        do: [],
        else: gen_coords(x_from, y_from, x_to, y_to)

    solve(rest, coords ++ path_coords, include_diagonal?)
  end

  def part_one(), do: load_data() |> solve([])

  def part_two(), do: load_data() |> solve([], true)
end
