defmodule AdventOfCode.DayFifteenSolution do
  @maze_size 100

  defp load_data() do
    AdventOfCode.load_data(15, "data.txt")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Matrex.new()
  end

  defp in_grid(row, col), do: row >= 1 and col >= 1 and row <= @maze_size and col <= @maze_size

  defp dijkstra(m, costs, unvisited) do
    if :queue.len(unvisited) == 0 do
      costs[@maze_size][@maze_size] - 1.0
    else
      {{:value, {{row, col}, cost}}, u_unvisited} = :queue.out(unvisited)

      neighbors =
        [
          {row - 1, col},
          {row + 1, col},
          {row, col - 1},
          {row, col + 1}
        ]
        |> Enum.filter(fn {ar, ac} -> in_grid(ar, ac) end)
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

      dijkstra(m, updated_costs, updated_unvisited)
    end
  end

  defp prioritize_queue(q) do
    q
    |> :queue.to_list()
    |> Enum.sort_by(fn {_, c} -> c end)
    |> Enum.reduce(:queue.new(), fn el, acc -> :queue.in(el, acc) end)
  end

  def part_one() do
    m = load_data()
    costs = Matrex.new(@maze_size, @maze_size, fn -> 9_9999 end) |> Matrex.set(1, 1, m[1][1])
    unvisited = :queue.new() |> then(fn q -> :queue.in({{1, 1}, m[1][1]}, q) end)
    dijkstra(m, costs, unvisited)
  end
end
