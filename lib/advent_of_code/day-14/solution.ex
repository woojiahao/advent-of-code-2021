defmodule AdventOfCode.DayFourteenSolution do
  defp load_data do
    [template, raw_rules] =
      AdventOfCode.load_data(14, "data.txt", true)
      |> String.split("\n\n", trim: true)

    rules =
      raw_rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " -> ", trim: true))
      |> Map.new(fn [pair, insertion] -> {pair, insertion} end)

    {template, rules}
  end

  defp polymerize(polymer, rules) do
    pairs = polymer |> String.graphemes() |> Enum.chunk_every(2, 1)

    Enum.reduce(pairs, "", fn
      [last], acc ->
        acc <> last

      pair, acc ->
        rule = rules[Enum.join(pair)]
        new = Enum.at(pair, 0) <> rule
        acc <> new
    end)
  end

  def part_one() do
    {template, rules} = load_data()

    {{_, a}, {_, b}} =
      Enum.reduce(0..9, template, fn _, polymer -> polymerize(polymer, rules) end)
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_, v} -> v end)

    abs(a - b)
  end
end
