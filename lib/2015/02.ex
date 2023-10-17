import AdventOfCode

advent_of_code 2015, 2 do
  @moduledoc """
  https://adventofcode.com/2015/day/2
  https://adventofcode.com/2015/day/2/input
  """

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line |> String.split("x") |> Enum.map(&String.to_integer/1)
  end

  @doc """
  ## Examples
      iex> "2x3x4" |> part_1()
      58

      iex> "1x1x10" |> part_1()
      43

      iex> input() |> part_1()
      1606483
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.map(&wrapping_paper/1)
    |> Enum.sum()
  end

  defp wrapping_paper([l, w, h]) do
    areas = [l * w, w * h, h * l] |> Enum.sort()
    Enum.sum(areas) * 2 + List.first(areas)
  end

  @doc """
  ## Examples
      iex> "2x3x4" |> part_2()
      34

      iex> "1x1x10" |> part_2()
      14

      # iex> input() |> part_2()
      # 3842356
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Enum.map(&ribbon/1)
    |> Enum.sum()
  end

  defp ribbon(sides) do
    ribbon = sides |> Enum.sort() |> Enum.take(2) |> Enum.sum() |> (&(&1 * 2)).()
    ribbon + Enum.product(sides)
  end
end
