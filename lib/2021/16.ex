import AdventOfCode

advent_of_code 2021, 16 do
  @moduledoc """
  https://adventofcode.com/2021/day/16
  https://adventofcode.com/2021/day/16/input
  """

  defp parse_input(input) do
    input
    |> String.trim()
    |> Base.decode16!()
    |> parse_binary()
    |> elem(0)
  end

  defp parse_binary(<<version::3, 4::3, rest::bitstring>>) do
    {value, rest} = parse_literal(rest)
    {{version, 4, value}, rest}
  end

  defp parse_binary(
         <<version::3, type::3, 0::1, packet_length::15,
           subpackets::bitstring-size(packet_length), rest::bitstring>>
       ) do
    {{version, type, parse_multiple(subpackets)}, rest}
  end

  defp parse_binary(<<version::3, type::3, 1::1, packet_length::11, rest::bitstring>>) do
    {subpackets, rest} = num_packets(rest, packet_length)
    {{version, type, subpackets}, rest}
  end

  defp parse_literal(bin, value \\ 0)
  defp parse_literal(<<0::1, data::4, rest::bitstring>>, value), do: {value * 16 + data, rest}

  defp parse_literal(<<1::1, data::4, rest::bitstring>>, value),
    do: parse_literal(rest, value * 16 + data)

  defp parse_multiple(binary, packets \\ []) do
    case parse_binary(binary) do
      {packet, <<>>} -> [packet | packets] |> Enum.reverse()
      {packet, rest} -> parse_multiple(rest, [packet | packets])
    end
  end

  defp num_packets(binary, count, list \\ [])
  defp num_packets(rest, 0, list), do: {Enum.reverse(list), rest}

  defp num_packets(binary, count, list) do
    {packet, rest} = parse_binary(binary)
    num_packets(rest, count - 1, [packet | list])
  end

  @doc """
  ## Examples
      iex> "8A004A801A8002F478" |> part_1()
      16

      iex> "D2FE28" |> part_1()
      6

      iex> "620080001611562C8802118E34" |> part_1()
      12

      iex> "C0015000016115A2E0802F182340" |> part_1()
      23

      iex> "A0016C880162017C3686B18A3D4780" |> part_1()
      31

      iex> input() |> part_1()
      929
  """
  def part_1(input) do
    input |> parse_input() |> sum_versions()
  end

  defp sum_versions([]), do: 0
  defp sum_versions([packet | rest]), do: sum_versions(packet) + sum_versions(rest)
  defp sum_versions({version, 4, _}), do: version
  defp sum_versions({version, _, subpackets}), do: version + sum_versions(subpackets)

  @doc """
  ## Examples
      iex> "C200B40A82" |> part_2()
      3

      iex> "04005AC33890" |> part_2()
      54

      iex> "880086C3E88112" |> part_2()
      7

      iex> "CE00C43D881120" |> part_2()
      9

      iex> "D8005AC2A8F0" |> part_2()
      1

      iex> "F600BC2D8F" |> part_2()
      0

      iex> "9C005AC2F8F0" |> part_2()
      0

      iex> "9C0141080250320F1802104A08" |> part_2()
      1

      iex> input() |> part_2()
      911945136934
  """
  def part_2(input) do
    input |> parse_input() |> run()
  end

  defp run({_, 0, packets}), do: packets |> run() |> Enum.sum()
  defp run({_, 1, packets}), do: packets |> run() |> Enum.product()
  defp run({_, 2, packets}), do: packets |> run() |> Enum.min()
  defp run({_, 3, packets}), do: packets |> run() |> Enum.max()
  defp run({_, 4, value}), do: value
  defp run({_, 5, [a, b]}), do: if(run(a) > run(b), do: 1, else: 0)
  defp run({_, 6, [a, b]}), do: if(run(a) < run(b), do: 1, else: 0)
  defp run({_, 7, [a, b]}), do: if(run(a) == run(b), do: 1, else: 0)
  defp run(packets) when is_list(packets), do: Enum.map(packets, &run/1)
end
