defmodule AdventOfCode.DayTwelveSolution do
  defp load_data() do
    map =
      AdventOfCode.load_data(12, "data.txt")
      |> Enum.map(&String.split(&1, "-"))

    g = :digraph.new()

    map
    |> Enum.each(fn [s, e] ->
      as = String.to_atom(s)
      ae = String.to_atom(e)
      :digraph.add_vertex(g, as)
      :digraph.add_vertex(g, ae)
      :digraph.add_edge(g, as, ae)
      :digraph.add_edge(g, ae, as)
    end)

    g
  end

  defp walk(_, :end, _, path), do: [path]

  defp walk(g, cur, vs, path) do
    available = (:digraph.out_neighbours(g, cur) -- [:start]) -- vs

    available
    |> Enum.map(fn a ->
      u_vs = if Atom.to_string(a) == String.downcase(Atom.to_string(a)), do: vs ++ [a], else: vs
      walk(g, a, u_vs, path ++ [a])
    end)
    |> Enum.flat_map(& &1)
  end

  defp walk_two_visits(_, :end, _, path), do: [path]

  defp walk_two_visits(g, cur, vs, path) do
    # visited will be filled with all visited small caves if there is a small cave with 2
    visited = if Enum.any?(Map.values(vs), &(&1 == 2)), do: Map.keys(vs), else: []
    available = (:digraph.out_neighbours(g, cur) -- [:start]) -- visited

    available
    |> Enum.map(fn a ->
      u_vs =
        if Atom.to_string(a) == String.downcase(Atom.to_string(a)),
          do: Map.update(vs, a, 1, &(&1 + 1)),
          else: vs

      walk_two_visits(g, a, u_vs, path ++ [a])
    end)
    |> Enum.flat_map(& &1)
  end

  def part_one() do
    load_data() |> walk(:start, [], [:start]) |> length()
  end

  def part_two() do
    load_data() |> walk_two_visits(:start, %{}, [:start]) |> length()
  end
end
