defmodule AdventOfCode.DayNineSolution do
  # Alt solution is to manually check coords
  defp load_data() do
    m =
      AdventOfCode.load_data(9, 'data.txt')
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn i -> Enum.map(i, &String.to_integer/1) end)
      |> Matrex.new()

    {m, Matrex.size(m)}
  end

  # r and c represent the coords of the center point
  defp get_submatrix_size(r, c, max_r, max_c) do
    r_start = if r == 1, do: 1, else: r - 1
    r_end = if r == max_r, do: r, else: r + 1
    c_start = if c == 1, do: 1, else: c - 1
    c_end = if c == max_c, do: c, else: c + 1
    {r_start..r_end, c_start..c_end}
  end

  defp acc(data, acc_type \\ :value), do: acc(data, 1, 1, [], acc_type)

  defp acc({_, {max_r, _}}, r, _, acc, _) when r > max_r, do: acc

  defp acc({m, {max_r, max_c}}, r, c, acc, acc_type) when c > max_c,
    do: acc({m, {max_r, max_c}}, r + 1, 1, acc, acc_type)

  # Get from the sub-matrix
  defp acc({m, {max_r, max_c}}, r, c, acc, acc_type) do
    {rows, cols} = get_submatrix_size(r, c, max_r, max_c)
    sm = m |> Matrex.submatrix(rows, cols)
    center = m |> Matrex.at(r, c)
    sm_min = sm |> Matrex.min()
    is_center? = sm_min == center
    is_unique? = sm |> Enum.count(&(&1 == sm_min)) == 1

    v =
      case acc_type do
        :coords -> {r, c}
        :value -> center
        _ -> raise "invalid acc_type"
      end

    u_acc = if is_center? and is_unique?, do: [v], else: []

    acc({m, {max_r, max_c}}, r, c + 1, acc ++ u_acc, acc_type)
  end

  def part_one(),
    do:
      load_data()
      |> acc()
      |> Enum.map(&(&1 + 1))
      |> Enum.sum()

  # generate a graph of the adjacent nodes
  defp find_basin_dim(m, r, c, max_r, max_c) do
  end

  def part_two(),
    do:
      load_data()
      |> acc(:coords)
end
