defmodule AdventOfCode do
  @spec load_data(integer(), String.t()) :: list(String.t())
  def load_data(day, filename, raw \\ false) do
    lib_path = __ENV__.file |> Path.dirname()
    file_path = Path.join([lib_path, "advent_of_code", "day-#{day}", filename])
    parse_data(file_path, raw)
  end

  defp parse_data(file_path, true), do: File.read!(file_path)
  defp parse_data(file_path, false), do: File.read!(file_path) |> String.split("\n", trim: true)

  def time(function) do
    {_, _, start} = :os.timestamp()
    function.() |> IO.inspect()
    {_, _, stop} = :os.timestamp()
    "Time taken: #{(stop - start) / 1000}ms" |> IO.puts()
  end
end
