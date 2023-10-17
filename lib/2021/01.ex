import AdventOfCode

advent_of_code 2021, 1 do
  @moduledoc """
  https://adventofcode.com/2021/day/1
  https://adventofcode.com/2021/day/1/input
  """
  def sample() do
    """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
  end

  def parse_input(input), do: input |> String.split() |> Enum.map(&String.to_integer/1)

  @doc ~s"""
  ## Examples
      iex> sample() |> part_1()
      7

      iex> input() |> part_1()
      1665
  """
  def part_1(input) do
    input |> parse_input() |> count_increases()
  end

  defp count_increases(numbers) do
    numbers
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(&increments?/1)
  end

  defp increments?([a, b]) when b > a, do: true
  defp increments?(_), do: false

  @doc ~S"""
  ## Examples
      iex> sample() |> part_2()
      5

      iex> input() |> part_2()
      1702
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> count_increases()
  end
end
