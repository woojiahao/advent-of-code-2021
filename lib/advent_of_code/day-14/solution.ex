defmodule AdventOfCode.DayFourteenSolution do
  defp load_data do
    [template, raw_rules] =
      AdventOfCode.load_data(14, "data.txt", true)
      |> String.split("\n\n", trim: true)

    rules =
      raw_rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " -> ", trim: true))
      |> Map.new(fn [pair, insertion] -> {String.graphemes(pair), insertion} end)

    {template, rules}
  end

  defp polymerize(polymer, rules) do
    polymer
    |> Enum.reduce(polymer, fn {[f, b] = pair, count}, acc ->
      rule = rules[pair]

      acc
      |> Map.update([f, rule], count, &(&1 + count))
      |> Map.update([rule, b], count, &(&1 + count))
      |> Map.update([f, b], 0, fn x -> max(0, x - count) end)
    end)
  end

  defp solve(template, rules, n) do
    [last_el | _] = template |> String.graphemes() |> Enum.reverse()

    polymer =
      template |> String.graphemes() |> Enum.chunk_every(2, 1, :discard) |> Enum.frequencies()

    {{_, a}, {_, b}} =
      Enum.reduce(0..(n - 1), polymer, fn _, polymer -> polymerize(polymer, rules) end)
      |> Enum.map(fn {[f, _], c} -> {f, c} end)
      |> Enum.reduce(%{}, fn {l, c}, acc -> acc |> Map.update(l, c, &(&1 + c)) end)
      |> Map.update(last_el, -1, &(&1 + 1))
      |> Enum.min_max_by(fn {_, v} -> v end)

    abs(a - b)
  end

  def part_one() do
    {template, rules} = load_data()
    solve(template, rules, 10)
  end

  def part_two() do
    {template, rules} = load_data()
    solve(template, rules, 40)
  end
end
