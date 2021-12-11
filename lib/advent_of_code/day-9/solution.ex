defmodule AdventOfCode.DayNineSolution.Location do
  defstruct [:coords, :height]
end

defmodule AdventOfCode.DayNineSolution do
  alias AdventOfCode.DayNineSolution.Location, as: Location

  # Alt solution is to manually check coords
  defp load_data() do
    m =
      AdventOfCode.load_data(9, 'data.txt')
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn i -> Enum.map(i, &String.to_integer/1) end)
      |> Matrex.new()

    {max_r, max_c} = Matrex.size(m)

    gen_graph(m, 1, 1, max_r, max_c, :digraph.new(), [])
  end

  defp find_pt(pts, r, c),
    do: pts |> Enum.find(fn %{coords: {row, col}} -> row == r and col == c end)

  defp gen_graph(_, r, _, max_r, _, g, pts) when r > max_r, do: {g, pts}

  defp gen_graph(m, r, c, max_r, max_c, g, pts) when c > max_c,
    do: gen_graph(m, r + 1, 1, max_r, max_c, g, pts)

  defp gen_graph(m, r, c, max_r, max_c, g, pts) do
    up = if r == 1, do: nil, else: {r - 1, c}
    down = if r == max_r, do: nil, else: {r + 1, c}
    left = if c == 1, do: nil, else: {r, c - 1}
    right = if c == max_c, do: nil, else: {r, c + 1}

    cur = %Location{coords: {r, c}, height: m[r][c]}
    :digraph.add_vertex(g, cur)

    [up, down, left, right]
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(fn {row, col} ->
      pt = %Location{coords: {row, col}, height: m[row][col]}
      :digraph.add_vertex(g, pt)
      :digraph.add_edge(g, cur, pt)
    end)

    gen_graph(m, r, c + 1, max_r, max_c, g, [cur | pts])
  end

  def part_one() do
    {g, pts} = load_data()

    pts
    |> Enum.filter(fn pt ->
      :digraph.out_neighbours(g, pt) |> Enum.all?(fn %{height: h} -> h > pt.height end)
    end)
    |> Enum.map(fn %{height: h} -> h + 1 end)
    |> Enum.sum()
  end

  def part_two(),
    do: load_data()
end
