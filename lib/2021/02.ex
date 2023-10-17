import AdventOfCode

advent_of_code 2021, 2 do
  @moduledoc """
  https://adventofcode.com/2021/day/2
  https://adventofcode.com/2021/day/2/input
  """
  def sample() do
    """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("forward " <> num), do: {:forward, String.to_integer(num)}
  defp parse_line("down " <> num), do: {:down, String.to_integer(num)}
  defp parse_line("up " <> num), do: {:up, String.to_integer(num)}

  @doc ~s"""
  ## Examples
      iex> sample() |> part_1()
      150

      iex> input() |> part_1()
      1250395
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.reduce({0, 0}, &move/2)
    |> Tuple.to_list()
    |> Enum.product()
  end

  defp move({:forward, amount}, {x, y}), do: {x + amount, y}
  defp move({:down, amount}, {x, y}), do: {x, y + amount}
  defp move({:up, amount}, {x, y}), do: {x, y - amount}

  defp move({:forward, amount}, {x, y, aim}), do: {x + amount, y + aim * amount, aim}
  defp move({:down, amount}, {x, y, aim}), do: {x, y, aim + amount}
  defp move({:up, amount}, {x, y, aim}), do: {x, y, aim - amount}

  @doc ~s"""
  ## Examples
      iex> sample() |> part_2()
      900

      iex> input() |> part_2()
      1451210346
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Enum.reduce({0, 0, 0}, &move/2)
    |> Tuple.to_list()
    |> Enum.take(2)
    |> Enum.product()
  end
end
