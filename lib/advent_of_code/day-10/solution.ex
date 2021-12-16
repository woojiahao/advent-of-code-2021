defmodule AdventOfCode.DayTenSolution do
  @tags %{
    "]" => "[",
    "}" => "{",
    ">" => "<",
    ")" => "("
  }
  @opening ~w([ { < \()
  @illegal_cost %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }
  @incomplete_cost %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  defp load_data(), do: AdventOfCode.load_data(10, "data.txt") |> Enum.map(&String.graphemes/1)

  defp check([], acc, illegal), do: {acc, illegal}

  defp check([c | rest], acc, illegal) when c in @opening, do: check(rest, acc ++ [c], illegal)

  defp check([c | rest], acc, illegal) do
    expected = @tags[c]
    latest = List.last(acc)
    remaining = acc |> Enum.slice(0, length(acc) - 1)

    if latest == expected,
      do: check(rest, remaining, illegal),
      else: check(rest, remaining, illegal ++ [{latest, c}])
  end

  def part_one() do
    load_data()
    |> Enum.map(&check(&1, [], []))
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.map(&@illegal_cost[elem(&1, 1)])
    |> Enum.sum()
  end

  def part_two() do
    load_data() |> length() |> IO.inspect()

    costs =
      load_data()
      |> Enum.map(&check(&1, [], []))
      |> Enum.filter(&(length(elem(&1, 1)) == 0))
      |> Enum.map(fn {openings, _} ->
        Enum.reduce(
          Enum.reverse(openings),
          0,
          fn c, acc -> acc * 5 + @incomplete_cost[c] end
        )
      end)
      |> Enum.sort()

    costs |> IO.inspect()
    length(costs) |> IO.inspect()

    middle = Enum.at(costs, div(length(costs), 2))
    middle
  end
end
