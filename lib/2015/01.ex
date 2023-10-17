import AdventOfCode

advent_of_code 2015, 1 do
  @moduledoc """
  https://adventofcode.com/2015/day/1
  https://adventofcode.com/2015/day/1/input
  """

  @doc """
  ## Examples
      iex> "(())" |> part_1()
      0

      iex> "()()" |> part_1()
      0

      iex> "(((" |> part_1()
      3

      iex> "(()(()(" |> part_1()
      3

      iex> "))(((((" |> part_1()
      3

      iex> "())" |> part_1()
      -1

      iex> "))(" |> part_1()
      -1

      iex> ")))" |> part_1()
      -3

      iex> ")())())" |> part_1()
      -3

      iex> input() |> part_1()
      74
  """
  def part_1(input) do
    input |> String.trim() |> move(0)
  end

  defp move("", floor), do: floor
  defp move("(" <> rest, floor), do: move(rest, floor + 1)
  defp move(")" <> rest, floor), do: move(rest, floor - 1)

  @doc """
  ## Examples
      iex> ")" |> part_2()
      1

      iex> "()())" |> part_2()
      5

      iex> input() |> part_2()
      1795
  """
  def part_2(input) do
    input |> String.trim() |> move(0, 0)
  end

  defp move(_, -1, step), do: step
  defp move("", _, _), do: -1
  defp move("(" <> rest, floor, step), do: move(rest, floor + 1, step + 1)
  defp move(")" <> rest, floor, step), do: move(rest, floor - 1, step + 1)
end
