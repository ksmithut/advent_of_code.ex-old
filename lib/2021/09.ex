import AdventOfCode

advent_of_code 2021, 9 do
  @moduledoc """
  https://adventofcode.com/2021/day/9
  https://adventofcode.com/2021/day/9/input
  """
  def sample() do
    """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {num, x}, map -> Map.put(map, {x, y}, String.to_integer(num)) end)
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      15

      iex> input() |> part_1()
      439
  """
  def part_1(input) do
    input
    |> parse_input()
    |> find_low_points()
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  defp find_low_points(map) do
    Enum.filter(map, fn {pos, val} ->
      pos
      |> neighbors()
      |> Enum.map(&Map.get(map, &1))
      |> Enum.reject(&is_nil/1)
      |> Enum.all?(fn neighbor -> neighbor > val end)
    end)
  end

  defp neighbors({x, y}), do: [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]

  @doc """
  ## Examples
      iex> sample() |> part_2()
      1134

      iex> input() |> part_2()
      900900
  """
  def part_2(input) do
    map = parse_input(input)

    find_low_points(map)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&fill_basin(map, &1))
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp fill_basin(map, point, visited \\ MapSet.new()) do
    point
    |> neighbors()
    |> Enum.reject(&(MapSet.member?(visited, &1) or Map.get(map, &1, 9) === 9))
    |> Enum.reduce(MapSet.put(visited, point), &fill_basin(map, &1, &2))
  end
end
