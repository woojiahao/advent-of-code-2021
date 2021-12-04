defmodule DayFourSolution do
  defp load_data() do
    [draw | rest] = File.read!("data.txt") |> String.split("\n", trim: true)

    boards =
      rest
      |> Enum.map(fn row -> String.split(row) end)
      |> Enum.chunk_every(5)
      |> Enum.map(&load_board/1)

    draw_list = draw |> String.split(",") |> Enum.map(&String.to_integer/1)

    {draw_list, boards}
  end

  # Initialize an empty board to work with
  defp create_empty_board() do
    %{
      0 => %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1},
      1 => %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1},
      2 => %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1},
      3 => %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1},
      4 => %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1}
    }
  end

  # Set the element of a board at [row][col]
  defp set_element(board, row, col, value), do: update_in(board[row][col], &(&1 + -&1 + value))

  # Public facing find_element_index
  defp find_element_index(board, target), do: find_element_index(board, 0, 0, target)

  # Search for an element and return the given index within the board
  defp find_element_index(_, 5, 0, _), do: nil

  defp find_element_index(board, row, 4, target) do
    if board[row][4] == target,
      do: {row, 4},
      else: find_element_index(board, row + 1, 0, target)
  end

  defp find_element_index(board, row, col, target) do
    if board[row][col] == target,
      do: {row, col},
      else: find_element_index(board, row, col + 1, target)
  end

  # Multi-dimensional array at [row][col]
  defp mda_at(mda, row, col), do: mda |> Enum.at(row) |> Enum.at(col) |> String.to_integer()

  # Public facing load_board
  defp load_board(data), do: load_board(data, 0, 0, %{})

  # If the row is already five and col is already one, the board has been filled
  defp load_board(_, 5, 0, board), do: board

  # If we start loading at the first row/col, we want to create a new board
  defp load_board(data, 0, 0, _) do
    el = data |> mda_at(0, 0)
    updated_board = create_empty_board() |> set_element(0, 0, el)
    load_board(data, 0, 1, updated_board)
  end

  # If we have come to the last col, move one row down and start at zero
  defp load_board(data, row, 4, board) do
    el = data |> mda_at(row, 4)
    updated_board = board |> set_element(row, 4, el)
    load_board(data, row + 1, 0, updated_board)
  end

  # If we haven't reached any of the edges/corners, just update the board at [row][col]
  defp load_board(data, row, col, board) do
    el = data |> mda_at(row, col)
    updated_board = board |> set_element(row, col, el)
    load_board(data, row, col + 1, updated_board)
  end

  defp fill_draw(draw, board) do
    index = find_element_index(board, draw)

    unless index == nil do
      {row, col} = index
      updated_board = set_element(board, row, col, -1)
      updated_board
    else
      board
    end
  end

  defp is_row_bingo?(board, row), do: board[row] |> Map.values() |> Enum.all?(&(&1 == -1))

  # Public facing is_col_bingo?
  defp is_col_bingo?(board, col), do: is_col_bingo?(board, 0, col, [])

  defp is_col_bingo?(_, 5, _, outcome), do: outcome |> Enum.all?()

  defp is_col_bingo?(board, row, col, outcome),
    do: is_col_bingo?(board, row + 1, col, [board[row][col] == -1 | outcome])

  # To find bingo, we generate a map containing true and false and apply & to all the values
  defp has_bingo?(board) do
    indices = 0..4 |> Enum.to_list()
    has_row_bingo? = indices |> Enum.any?(&is_row_bingo?(board, &1))
    has_col_bingo? = indices |> Enum.any?(&is_col_bingo?(board, &1))
    has_row_bingo? || has_col_bingo?
  end

  defp get_unmarked(board), do: get_unmarked(board, 0, 0, 0)

  defp get_unmarked(board, 5, 0, unmarked), do: unmarked

  defp get_unmarked(board, row, 4, unmarked) do
    x = if board[row][4] == -1, do: 0, else: board[row][4]
    get_unmarked(board, row + 1, 0, unmarked + x)
  end

  defp get_unmarked(board, row, col, unmarked) do
    x = if board[row][col] == -1, do: 0, else: board[row][col]
    get_unmarked(board, row, col + 1, unmarked + x)
  end

  defp solve_one({[draw | rest], boards}) do
    # Take the next set of draws and update the board accordingly
    updated_boards = boards |> Enum.map(&fill_draw(draw, &1))

    # Check if any of the boards have bingo
    any_bingos? = updated_boards |> Enum.map(&has_bingo?/1) |> Enum.find_index(&(&1 == true))

    unless any_bingos? == nil do
      bingo_board = updated_boards |> Enum.at(any_bingos?)
      unmarked = bingo_board |> get_unmarked()
      unmarked * draw
    else
      solve_one({rest, updated_boards})
    end
  end

  def part_one(), do: load_data() |> solve_one()

  defp solve_two({[draw | rest], unsolved_boards}) do
    updated_boards = unsolved_boards |> Enum.map(&fill_draw(draw, &1))

    updated_unsolved_boards = updated_boards |> Enum.filter(&(!has_bingo?(&1)))

    if updated_unsolved_boards |> Enum.empty?() do
      last_board = updated_boards |> Enum.at(0)
      unmarked = last_board |> get_unmarked()
      unmarked * draw
    else
      solve_two({rest, updated_unsolved_boards})
    end
  end

  def part_two(), do: load_data() |> solve_two()
end
