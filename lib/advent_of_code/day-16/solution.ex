"""
101 (version 5)
000 (type 0)
  0 (type length id)
  000000001011011 (subpacket length 91)
  001 (version 1)
  000 (type 0)
    1 (type length id)
    00000000001 (subpackets 1)
      011 (version 3)
      000 (type 0)
      1 (type length id)
      00000000101 (subpackets 5)
        111 (version 7)
        100 (type 4)
        00110

        110 (version 6)
        100 (type 4)
        00110

        101
        100
        01100

        010
        100
        01111

        010
        100
        01111 (subpackets)
  0000000 (discard)
"""

defmodule AdventOfCode.DaySixteenSolution do
  @hexmap %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }
  @inverse_hexmap Map.new(@hexmap, fn {k, v} -> {v, k} end)

  defp load_data() do
    AdventOfCode.load_data(16, "example.txt", true)
    |> String.graphemes()
    |> Enum.map(&@hexmap[&1])
    |> Enum.join()
    |> String.graphemes()
  end

  defp to_int(p), do: p |> Enum.join() |> Integer.parse(2) |> elem(0)

  defp extract_header(packet, start),
    do:
      packet
      |> Enum.slice(start, 3)
      |> Enum.join()
      |> String.pad_leading(4, "0")
      |> then(&Map.get(@inverse_hexmap, &1))

  defp extract("4", body), do: extract_literal(body)
  defp extract(_, body), do: extract_operator(body)

  defp extract_literal(body) do
    parts = body |> Enum.chunk_every(5)

    ending = parts |> Enum.find_index(fn [h | _] -> h == "0" end)
    literal = Enum.slice(parts, 0, ending + 1) |> to_int()
    remaining = Enum.slice(parts, (ending + 1)..(length(parts) - 1))
    {:literal, literal, remaining}
  end

  defp extract_operator(["0" | body]) do
    subpackets_length = Enum.slice(body, 0, 15) |> to_int()
    to_parse = Enum.slice(body, 15..subpackets_length)
    {:fixed, to_parse, nil}
  end

  defp extract_operator(["1" | body]) do
    subpackets_count = Enum.slice(body, 0, 11) |> to_int()
    to_parse = Enum.slice(body, 11..(length(body) - 1))
    {:count, to_parse, subpackets_count}
  end

  defp parse([], _, state), do: state

  defp parse(packet, type, state) do
    packet |> IO.inspect(label: "packet")
    version = extract_header(packet, 0) |> IO.inspect(label: "version")
    type = extract_header(packet, 3) |> IO.inspect(label: "type")
    rest = Enum.slice(packet, 6..(length(packet) - 1)) |> IO.inspect(label: "rest")
    IO.puts("")

    if length(rest) == 0 do
      state
    else
      case extract(type, rest) do
        {:literal, literal, remaining} ->
          literal |> IO.inspect(label: "literal")
          parse(remaining, :literal, state)

        {:fixed, to_parse, _} ->
          to_parse |> IO.inspect(label: "fixed subpacket")
          parse(to_parse, :fixed, state)

        {:count, to_parse, _} ->
          to_parse |> IO.inspect(label: "count subpacket")
          parse(to_parse, :count, state)
      end
    end
  end

  def part_one(i) do
    packet = load_data()

    test =
      i
      |> String.graphemes()
      |> Enum.map(&@hexmap[&1])
      |> Enum.join()
      |> String.graphemes()

    parse(test, :packet, %{})
    # parse(packet)
  end
end
