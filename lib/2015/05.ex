import AdventOfCode

advent_of_code 2015, 5 do
  @moduledoc """
  https://adventofcode.com/2015/day/5
  https://adventofcode.com/2015/day/5/input
  """

  @doc """
  ## Examples
      iex> "ugknbfddgicrmopn" |> part_1()
      1

      iex> "aaa" |> part_1()
      1

      iex> "jchzalrnumimnmhp" |> part_1()
      0

      iex> "haegwjzuvuyypxyu" |> part_1()
      0

      iex> "dvszwmarrgswjxmb" |> part_1()
      0

      iex> input() |> part_1()
      238
  """
  def part_1(input) do
    input
    |> String.split()
    |> Enum.count(&nice?/1)
  end

  def nice?(string) do
    String.match?(string, ~r/([aeiou].*){3}/) and
      String.match?(string, ~r/(.)\1/) and
      !String.match?(string, ~r/(ab|cd|pq|xy)/)
  end

  @doc """
  ## Examples
      iex> "qjhvhtzxzqqjkmpb" |> part_2()
      1

      iex> "xxyxx" |> part_2()
      1

      iex> "uurcxstgmygtbstg" |> part_2()
      0

      iex> "ieodomkazucvgmuy" |> part_2()
      0

      iex> input() |> part_2()
      69
  """
  def part_2(input) do
    input
    |> String.split()
    |> Enum.count(&nice2?/1)
  end

  defp nice2?(string) do
    String.match?(string, ~r/(..).*\1/) and
      String.match?(string, ~r/(.).\1/)
  end
end
