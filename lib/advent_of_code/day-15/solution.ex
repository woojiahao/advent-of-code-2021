defmodule AdventOfCode.DayFifteenSolution do
  @maze_size 9

  defp load_data() do
    points =
      AdventOfCode.load_data(15, "example.txt")
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, r} ->
        l
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index()
        |> Enum.map(fn {i, c} -> {{r, c}, i} end)
      end)

    g = :digraph.new()

    points
    |> Enum.each(fn {coords, i} ->
      :digraph.add_vertex(g, coords, i)
    end)

    points
    |> Enum.each(fn {{r, c}, _} ->
      [{r, c - 1}, {r, c + 1}, {r - 1, c}, {r + 1, c}]
      |> Enum.filter(fn {ar, ac} ->
        ar >= 0 and ac >= 0 and ar <= @maze_size and ac <= @maze_size
      end)
      |> Enum.each(fn {ar, ac} ->
        :digraph.add_edge(g, {r, c}, {ar, ac})
        :digraph.add_edge(g, {ar, ac}, {r, c})
      end)
    end)

    g
  end

  defp walk(_, {@maze_size, @maze_size}, _, path_cost), do: [path_cost - 1]

  defp walk(g, cur, unvisited, path_cost) do
    cur |> IO.inspect()
    u_unvisited = MapSet.delete(unvisited, cur)
    neighbors = g |> :digraph.out_neighbours(cur) |> MapSet.new()
    available = MapSet.intersection(neighbors, u_unvisited) |> IO.inspect()

    available
    |> Enum.map(fn a ->
      {_, cost} = :digraph.vertex(g, cur)
      walk(g, a, u_unvisited, path_cost + cost)
    end)
    |> Enum.flat_map(& &1)
  end

  def part_one() do
    # load_data() |> :digraph.out_neighbours({4, 1})
    all = for r <- 0..@maze_size, c <- 0..@maze_size, do: {r, c}
    load_data() |> walk({0, 0}, MapSet.new(all), 0)
  end
end
