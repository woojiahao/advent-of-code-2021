defmodule AdventOfCode do
  @spec load_data(integer(), String.t()) :: list(String.t())
  def load_data(day, filename) do
    lib_path = __ENV__.file |> Path.dirname()
    file_path = Path.join([lib_path, "advent_of_code", "day-#{day}", filename])
    File.read!(file_path) |> String.split("\n", trim: true)
  end
end
