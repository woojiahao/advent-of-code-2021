defmodule AdventOfCode.DaySeventeenSolution do
  defp load_data() do
    raw_target = AdventOfCode.load_data(17, "data.txt", true)

    target_area =
      Regex.run(
        ~r/^target area\: x=(\-?\d+)\.\.(\-?\d+), y=(\-?\d+)\.\.(\-?\d+)$/,
        raw_target,
        capture: :all_but_first
      )
      |> Enum.map(&String.to_integer/1)

    target_area
  end

  defp x_possible?(_, dist, _, x_end) when dist > x_end, do: false
  defp x_possible?(_, dist, x_start, _) when dist >= x_start, do: true
  defp x_possible?(move, _, _, _) when move == 0, do: nil

  defp x_possible?(move, dist, x_start, x_end),
    do: x_possible?(max(move - 1, 0), dist + move, x_start, x_end)

  defp step(x, y, x_start, x_end, y_start, y_end),
    do: step(x, y, x, y, x_start, x_end, y_start, y_end)

  defp step(_, _, x_pos, y_pos, x_start, x_end, y_start, y_end)
       when x_pos in x_start..x_end and y_pos in y_start..y_end,
       do: {:hit, {x_pos, y_pos}}

  defp step(_, _, x_pos, y_pos, _, x_end, y_start, _)
       when x_pos > x_end or y_pos < y_start,
       do: {:miss, :past_target}

  defp step(x_step, y_step, x_pos, y_pos, x_start, x_end, y_start, y_end) do
    new_x_step = max(0, x_step - 1)
    new_y_step = y_step - 1
    new_x = x_pos + new_x_step
    new_y = y_pos + new_y_step
    step(new_x_step, new_y_step, new_x, new_y, x_start, x_end, y_start, y_end)
  end

  defp find_valid_velocities([x_start, x_end, y_start, y_end], allow_negative? \\ false) do
    possible_x = 0..x_end |> Enum.filter(&x_possible?(&1, 0, x_start, x_end))
    possible_y = if allow_negative?, do: y_start..abs(y_start), else: 0..abs(y_start)

    for x <- possible_x, y <- possible_y do
      {{x, y}, step(x, y, x_start, x_end, y_start, y_end)}
    end
    |> Enum.filter(fn {_, {status, _}} -> status == :hit end)
    |> Enum.map(fn {coords, _} -> coords end)
  end

  def part_one() do
    load_data()
    |> find_valid_velocities()
    |> Enum.map(&Enum.sum(0..elem(&1, 1)))
    |> Enum.max()
  end

  def part_two() do
    load_data()
    |> find_valid_velocities(true)
    |> length()
  end
end
