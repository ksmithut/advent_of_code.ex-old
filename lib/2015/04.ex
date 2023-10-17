import AdventOfCode

advent_of_code 2015, 4 do
  @moduledoc """
  https://adventofcode.com/2015/day/4
  https://adventofcode.com/2015/day/4/input
  """

  @doc """
  ## Examples
      iex> "abcdef" |> part_1()
      609043

      iex> "pqrstuv" |> part_1()
      1048970

      iex> input() |> part_1()
      282749
  """
  def part_1(input) do
    input |> String.trim() |> run("00000")
  end

  defp md5_hash(val), do: :crypto.hash(:md5, val) |> Base.encode16()

  defp run(string, prefix, num \\ 1) do
    "#{string}#{num}"
    |> md5_hash()
    |> String.starts_with?(prefix)
    |> if(do: num, else: run(string, prefix, num + 1))
  end

  @doc """
  ## Examples
      iex> input() |> part_2()
      9962624
  """
  def part_2(input) do
    input |> String.trim() |> run("000000")
  end
end
