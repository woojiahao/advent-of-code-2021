defmodule AdventOfCode.DayFifteenSolution do
  defp load_data() do
    AdventOfCode.load_data(15, "data.txt")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Matrex.new()
  end

  defp in_grid(row, col, dim), do: row >= 1 and col >= 1 and row <= dim and col <= dim

  defp dijkstra(m, costs, unvisited, dim) do
    if :queue.len(unvisited) == 0 do
      costs[dim][dim] - 1.0
    else
      {{:value, {{row, col}, cost}}, u_unvisited} = :queue.out(unvisited)

      neighbors =
        [
          {row - 1, col},
          {row + 1, col},
          {row, col - 1},
          {row, col + 1}
        ]
        |> Enum.filter(fn {ar, ac} -> in_grid(ar, ac, dim) end)
        |> Enum.filter(fn {ar, ac} -> costs[ar][ac] > cost + m[ar][ac] end)

      updated_costs =
        Enum.reduce(neighbors, costs, fn {r, c}, acc ->
          Matrex.set(acc, r, c, cost + m[r][c])
        end)

      updated_unvisited =
        Enum.reduce(neighbors, u_unvisited, fn {r, c}, acc ->
          :queue.in({{r, c}, updated_costs[r][c]}, acc)
        end)
        |> prioritize_queue()

      dijkstra(m, updated_costs, updated_unvisited, dim)
    end
  end

  defp prioritize_queue(q) do
    q
    |> :queue.to_list()
    |> Enum.sort_by(fn {_, c} -> c end)
    |> Enum.reduce(:queue.new(), fn el, acc -> :queue.in(el, acc) end)
  end

  defp solve(m) do
    {dim, _} = Matrex.size(m)
    costs = Matrex.new(dim, dim, fn -> 9_9999 end) |> Matrex.set(1, 1, m[1][1])
    unvisited = :queue.new() |> then(fn q -> :queue.in({{1, 1}, m[1][1]}, q) end)
    dijkstra(m, costs, unvisited, dim)
  end

  def part_one() do
    m = load_data()
    solve(m)
  end

  def part_two() do
    m = load_data()
    {dim, _} = Matrex.size(m)
    g = for x <- 0..4, y <- 0..4, do: {x, y}
    i = for row <- 1..dim, col <- 1..dim, do: {row, col}

    n_m =
      Enum.reduce(g, Matrex.new(dim * 5, dim * 5, fn -> 0 end), fn {row, col}, acc ->
        IO.puts("#{row}, #{col}")
        ui = i |> Enum.map(fn {r, c} -> {r + row * dim, c + col * dim} end)
        IO.inspect(List.first(ui))

        Enum.reduce(ui, acc, fn {r, c}, a ->
          Matrex.set(a, r, c, m[r - row * dim][c - col * dim] + row + col)
        end)
      end)
      |> Matrex.apply(fn v -> if v > 9, do: v - 9, else: v end)

    solve(n_m)
  end
end
