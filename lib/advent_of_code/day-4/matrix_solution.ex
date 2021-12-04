defmodule AdventOfCode.DayFourMatrixSolution do
  defp load_data() do
    [first | rest] = AdventOfCode.load_data(4, "data.txt")

    draws = first |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)

    boards =
      rest
      |> Enum.map(&String.split(&1))
      |> Enum.map(fn r -> Enum.map(r, &String.to_integer(&1)) end)
      |> Enum.chunk_every(5)
      |> Enum.map(&Matrex.new/1)

    {draws, boards}
  end

  defp mark_draw(board, draw), do: fill_draw(board, Matrex.find(board, draw))

  defp fill_draw(board, {row, col}), do: board |> Matrex.set(row, col, -1)

  defp fill_draw(board, nil), do: board

  defp has_direction_bingo?(board),
    do:
      board
      |> Matrex.to_list_of_lists()
      |> Enum.any?(fn r -> r |> Enum.all?(&(&1 == -1)) end)

  defp has_bingo?(board) do
    has_row_bingo? = has_direction_bingo?(board)
    has_col_bingo? = board |> Matrex.transpose() |> has_direction_bingo?()
    has_row_bingo? || has_col_bingo?
  end

  defp get_solution(board, draw), do: get_unmarked(board) * draw

  defp get_unmarked(board),
    do: board |> Matrex.to_list() |> Enum.filter(&(&1 != -1.0)) |> Enum.sum()

  defp solve_one({[draw | rest], boards}) do
    updated_boards = boards |> Enum.map(&mark_draw(&1, draw))

    any_bingos? = updated_boards |> Enum.map(&has_bingo?/1) |> Enum.find_index(&(&1 == true))

    unless any_bingos? == nil,
      do: updated_boards |> Enum.at(any_bingos?) |> get_solution(draw),
      else: solve_one({rest, updated_boards})
  end

  def part_one(), do: load_data() |> solve_one()

  defp solve_two({[draw | rest], unsolved_boards}) do
    updated_boards = unsolved_boards |> Enum.map(&mark_draw(&1, draw))

    updated_unsolved_boards = updated_boards |> Enum.filter(&(!has_bingo?(&1)))

    if updated_unsolved_boards |> Enum.empty?(),
      do: updated_boards |> Enum.at(0) |> get_solution(draw),
      else: solve_two({rest, updated_unsolved_boards})
  end

  def part_two(), do: load_data() |> solve_two()
end
