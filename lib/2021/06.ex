import AdventOfCode

advent_of_code 2021, 6 do
  @moduledoc """
  https://adventofcode.com/2021/day/6
  https://adventofcode.com/2021/day/6/input
  """
  def sample(), do: "3,4,3,1,2"

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      5934

      iex> input() |> part_1()
      395627
  """
  def part_1(input) do
    input
    |> parse_input()
    |> run_day(80)
  end

  defp run_day(map, 0), do: Map.values(map) |> Enum.sum()
  defp run_day(map, days), do: Enum.reduce(map, %{}, &day_part/2) |> run_day(days - 1)

  defp day_part({0, count}, map), do: day_part({7, count}, map) |> (&day_part({9, count}, &1)).()
  defp day_part({num, count}, map), do: Map.update(map, num - 1, count, fn num -> num + count end)

  # defp run_day(start, days, list \\ [])
  # defp run_day([], 1, list), do: list
  # defp run_day([], days, list), do: run_day(list, days - 1, [])
  # defp run_day([0 | rest], days, list), do: run_day(rest, days, [6, 8 | list])
  # defp run_day([head | rest], days, list), do: run_day(rest, days, [head - 1 | list])

  @doc """
  ## Examples
      iex> sample() |> part_2()
      26984457539

      iex> input() |> part_2()
      1767323539209
  """
  def part_2(input) do
    input
    |> parse_input()
    |> run_day(256)
  end
end
