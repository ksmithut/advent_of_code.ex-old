import AdventOfCode

advent_of_code 2021, 11 do
  @moduledoc """
  https://adventofcode.com/2021/day/11
  https://adventofcode.com/2021/day/11/input
  """
  def sample() do
    """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(&Integer.digits/1)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, y} ->
      line |> Enum.with_index() |> Enum.map(fn {value, x} -> {{x, y}, value} end)
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      1656

      iex> input() |> part_1()
      1640
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Stream.iterate(&step/1)
    |> Stream.map(&Enum.count(&1, fn {_, value} -> value === 0 end))
    |> Stream.take(101)
    |> Enum.sum()
  end

  defp step(map), do: map |> increment_all() |> flash() |> reset()

  defp increment_all(map), do: map |> Map.keys() |> Enum.reduce(map, &increment_key/2)

  defp increment_key(key, map) when is_map_key(map, key), do: Map.update!(map, key, &increment/1)
  defp increment_key(_, map), do: map

  defp increment(value) when is_integer(value), do: value + 1
  defp increment(value), do: value

  defp flash(map) do
    to_flash = map |> Enum.filter(&flash?/1) |> Enum.map(&elem(&1, 0))
    map = Enum.reduce(to_flash, map, &flash/2)
    if to_flash == [], do: map, else: flash(map)
  end

  defp flash(pos, map) do
    map = Map.put(map, pos, :flash)
    pos |> adjacent() |> Enum.reduce(map, &increment_key/2)
  end

  defp flash?({_, :flash}), do: false
  defp flash?({_, value}) when value > 9, do: true
  defp flash?(_), do: false

  defp adjacent({x, y}), do: for(x <- (x - 1)..(x + 1), y <- (y - 1)..(y + 1), do: {x, y})

  defp reset(map), do: Enum.reduce(map, map, &reset/2)
  defp reset({key, value}, map) when value > 9, do: Map.put(map, key, 0)
  defp reset(_, map), do: map

  @doc """
  ## Examples
      iex> sample() |> part_2()
      195

      iex> input() |> part_2()
      312
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Stream.iterate(&step/1)
    |> Stream.map(&Enum.all?(&1, fn {_, value} -> value === 0 end))
    |> Stream.take_while(&!/1)
    |> Enum.to_list()
    |> length()
  end
end
