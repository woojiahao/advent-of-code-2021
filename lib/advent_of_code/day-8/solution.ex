defmodule AdventOfCode.DayEightSolution do
  defp sort_str(s), do: s |> String.graphemes() |> Enum.sort() |> Enum.join()

  defp load_data(),
    do:
      AdventOfCode.load_data(8, 'data.txt')
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn [first, second] ->
        signals = String.split(first) |> Enum.map(&String.graphemes/1)
        output = String.split(second) |> Enum.map(&sort_str/1)
        {signals, output}
      end)

  defp solve_one([], total), do: total

  defp solve_one([output | rest], total) do
    c = output |> Enum.count(&(String.length(&1) in [2, 3, 4, 7]))
    solve_one(rest, total + c)
  end

  def part_one(), do: load_data() |> Enum.map(&elem(&1, 1)) |> solve_one(0)

  defp signal_map(k) do
    %{
      1 => Enum.find(k, &(length(&1) == 2)),
      4 => Enum.find(k, &(length(&1) == 4)),
      7 => Enum.find(k, &(length(&1) == 3)),
      8 => Enum.find(k, &(length(&1) == 7))
    }
  end

  defp decode_signals(s) do
    u = s |> Enum.filter(&(length(&1) not in [2, 3, 4, 7]))
    signals = signal_map(s)

    six = u |> Enum.find(&(length(&1 -- signals[1]) == 5))
    nine = u |> Enum.find(&(length(signals[4] -- &1) == 0))
    zero = u |> Enum.find(&(&1 not in [six, nine] and length(&1) == 6))

    two = u |> Enum.find(&(length(nine -- &1) == 2))
    three = u |> Enum.find(&(length(&1 -- signals[1]) == 3))
    five = u |> Enum.find(&(&1 not in [two, three] and length(&1) == 5))

    new = %{0 => zero, 2 => two, 3 => three, 5 => five, 6 => six, 9 => nine}

    signals
    |> Map.merge(new)
    |> Map.new(fn {k, v} -> {v |> Enum.join() |> sort_str(), k} end)
  end

  defp solve_two([], total), do: total

  defp solve_two([{signals, outputs} | rest], total) do
    d = decode_signals(signals)
    x = outputs |> Enum.map(&d[&1]) |> Enum.join() |> String.to_integer()
    solve_two(rest, total + x)
  end

  def part_two(), do: load_data() |> solve_two(0)
end
