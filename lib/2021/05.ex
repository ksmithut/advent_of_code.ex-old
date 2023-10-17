import AdventOfCode

advent_of_code 2021, 5 do
  @moduledoc """
  https://adventofcode.com/2021/day/5
  https://adventofcode.com/2021/day/5/input
  """
  def sample() do
    """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(fn part ->
      String.split(part, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      5

      iex> input() |> part_1()
      7436
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} -> x1 === x2 or y1 === y2 end)
    |> count_dangerous_points()
  end

  defp generate_line({{x1, y1}, {x2, y2}}) when x1 === x2 or y1 === y2,
    do: for(x <- x1..x2, y <- y1..y2, do: {x, y})

  # diagonal
  defp generate_line({{x1, y1}, {x2, y2}}), do: Enum.zip(x1..x2, y1..y2)

  defp count_dangerous_points(lines) do
    lines
    |> Enum.map(&generate_line/1)
    |> List.flatten()
    |> Enum.reduce(%{}, fn pos, acc -> Map.put(acc, pos, Map.get(acc, pos, 0) + 1) end)
    |> Enum.count(fn {_, val} -> val >= 2 end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      12

      iex> input() |> part_2()
      21104
  """
  def part_2(input) do
    input
    |> parse_input()
    |> count_dangerous_points()
  end
end
