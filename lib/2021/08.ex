import AdventOfCode

advent_of_code 2021, 8 do
  @moduledoc """
  https://adventofcode.com/2021/day/8
  https://adventofcode.com/2021/day/8/input
  """
  def sample() do
    """
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" | ")
    |> Enum.map(fn part ->
      part
      |> String.split()
      |> Enum.map(fn char ->
        char
        |> String.graphemes()
        |> MapSet.new()
      end)
    end)
    |> List.to_tuple()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      26

      iex> input() |> part_1()
      440
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn {_, digits}, total ->
      Enum.reduce(digits, total, fn
        digit, total ->
          total +
            case MapSet.size(digit) do
              2 -> 1
              3 -> 1
              4 -> 1
              7 -> 1
              _ -> 0
            end
      end)
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      61229

      iex> input() |> part_2()
      1046281
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Enum.map(&decode_line/1)
    |> Enum.map(&Integer.undigits/1)
    |> Enum.sum()
  end

  defp decode_line({signals, digits}) do
    by_size = Enum.group_by(signals, &MapSet.size/1)
    [one] = by_size[2]
    [seven] = by_size[3]
    [four] = by_size[4]
    [eight] = by_size[7]

    {[nine], size_6} =
      Enum.split_with(by_size[6], fn segments ->
        MapSet.difference(four, segments) |> MapSet.size() |> Kernel.===(0)
      end)

    {[zero], [six]} =
      Enum.split_with(size_6, fn segments ->
        MapSet.difference(one, segments) |> MapSet.size() |> Kernel.===(0)
      end)

    {[five], size_5} =
      Enum.split_with(by_size[5], fn segments ->
        MapSet.difference(segments, six) |> MapSet.size() |> Kernel.===(0)
      end)

    {[three], [two]} =
      Enum.split_with(size_5, fn segments ->
        MapSet.difference(one, segments) |> MapSet.size() |> Kernel.===(0)
      end)

    list = [zero, one, two, three, four, five, six, seven, eight, nine] |> Enum.with_index()

    Enum.map(digits, fn digit ->
      Enum.find(list, fn {segments, _} -> MapSet.equal?(digit, segments) end) |> elem(1)
    end)
  end
end
