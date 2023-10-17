import AdventOfCode

advent_of_code 2015, 3 do
  @moduledoc """
  https://adventofcode.com/2015/day/3
  https://adventofcode.com/2015/day/3/input
  """

  @doc """
  ## Examples
      iex> ">" |> part_1()
      2

      iex> "^>v<" |> part_1()
      4

      iex> "^v^v^v^v^v" |> part_1()
      2

      iex> input() |> part_1()
      2565
  """
  def part_1(input) do
    santas = [{0, 0}]

    input
    |> String.trim()
    |> run(santas, MapSet.new(santas))
  end

  def move("^", {x, y}), do: {x, y - 1}
  def move(">", {x, y}), do: {x + 1, y}
  def move("v", {x, y}), do: {x, y + 1}
  def move("<", {x, y}), do: {x - 1, y}

  defp run("", _, visited), do: MapSet.size(visited)

  defp run(<<char::bytes-size(1)>> <> dirs, [curr | rest], visited) do
    curr = move(char, curr)
    run(dirs, rest ++ [curr], MapSet.put(visited, curr))
  end

  @doc """
  ## Examples
      iex> "^v" |> part_2()
      3

      iex> "^>v<" |> part_2()
      3

      iex> "^v^v^v^v^v" |> part_2()
      11

      iex> input() |> part_2()
      2639
  """
  def part_2(input) do
    santas = [{0, 0}, {0, 0}]

    input
    |> String.trim()
    |> run(santas, MapSet.new(santas))
  end
end
