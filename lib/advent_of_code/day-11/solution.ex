defmodule AdventOfCode.DayElevenSolution do
  @cap 9
  @coords for r <- 0..@cap, c <- 0..@cap, do: {r, c}
  @neighbors @coords
             |> Map.new(fn {r, c} ->
               n =
                 [
                   {r - 1, c},
                   {r + 1, c},
                   {r, c - 1},
                   {r, c + 1},
                   {r - 1, c - 1},
                   {r - 1, c + 1},
                   {r + 1, c - 1},
                   {r + 1, c + 1}
                 ]
                 |> Enum.filter(fn {nr, nc} ->
                   nr >= 0 and nc >= 0 and nr <= @cap and nc <= @cap
                 end)

               {{r, c}, n}
             end)

  defp load_data() do
    AdventOfCode.load_data(11, "data.txt")
    |> Enum.map(&String.graphemes/1)
    |> Enum.flat_map(& &1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(@cap + 1)
    |> Enum.with_index()
    |> Enum.map(fn {r, row} ->
      r
      |> Enum.with_index()
      |> Enum.map(fn {c, col} -> {{row, col}, c} end)
    end)
    |> Enum.flat_map(& &1)
    |> Map.new()
  end

  defp update_n(g, [], _), do: g
  defp update_n(g, [n | rest], f), do: update_n(g |> Map.update(n, 0, &f.(&1)), rest, f)

  defp propagate(g, flashed, true), do: {g, flashed}

  defp propagate(g, flashed, false) do
    flashing = g |> Enum.filter(&(elem(&1, 1) > 9)) |> Enum.map(&elem(&1, 0)) |> MapSet.new()
    u_flashed = MapSet.union(flashed, flashing)

    u_g =
      g
      |> Enum.reduce(g, fn
        {{k, v}, s}, acc when s > 9 ->
          acc
          |> Map.update({k, v}, 0, fn _ -> 0 end)
          |> update_n(@neighbors[{k, v}], &(&1 + 1))

        _, acc ->
          acc
      end)

    a_g = u_g |> update_n(MapSet.to_list(u_flashed), fn _ -> 0 end)

    propagate(a_g, u_flashed, a_g |> Map.values() |> Enum.all?(&(&1 <= 9)))
  end

  defp step(g) do
    ug = g |> Map.new(fn {{k, v}, s} -> {{k, v}, s + 1} end)
    propagate(ug, MapSet.new(), false)
  end

  defp solve_one(_, total, 0), do: total

  defp solve_one(g, total, n) do
    {u_g, flashed} = step(g)
    solve_one(u_g, total + MapSet.size(flashed), n - 1)
  end

  def part_one() do
    g = load_data()
    solve_one(g, 0, 100)
  end

  defp solve_two(g, n) do
    {u_g, _} = step(g)

    if Map.values(u_g) |> Enum.all?(&(&1 == 0)),
      do: n,
      else: solve_two(u_g, n + 1)
  end

  def part_two() do
    g = load_data()
    solve_two(g, 1)
  end
end
