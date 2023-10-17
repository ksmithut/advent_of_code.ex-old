import AdventOfCode

advent_of_code 2021, 25 do
  @moduledoc """
  https://adventofcode.com/2021/day/25
  https://adventofcode.com/2021/day/25/input
  """
  def sample() do
    """
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      58

      iex> input() |> part_1()
      295
  """
  def part_1(input) do
    input
    |> parse_input()
    |> run()
  end

  defp run(map, times \\ 0, moved \\ true)

  defp run(map, times, false) do
    {{{min_x, min_y}, _}, {{max_x, max_y}, _}} = Enum.min_max_by(map, fn {{x, y}, _} -> x + y end)

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x -> Map.get(map, {x, y}) end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> IO.puts()

    times
  end

  defp run(map, times, _) do
    {map, moved} = Enum.reduce(map, {map, false}, &move(&1, &2, map, ">"))
    {map, moved} = Enum.reduce(map, {map, moved}, &move(&1, &2, map, "v"))
    run(map, times + 1, moved)
  end

  defp move({pos, cell}, {new_map, moved}, map, only) when cell == only do
    next_pos = next(map, pos, cell)

    case Map.get(map, next_pos) do
      "." -> {new_map |> Map.put(next_pos, cell) |> Map.put(pos, "."), true}
      _ -> {Map.put(new_map, pos, cell), moved}
    end
  end

  defp move(_, acc, _, _), do: acc

  defp next(map, {x, y}, "v") when is_map_key(map, {x, y + 1}), do: {x, y + 1}
  defp next(_, {x, _}, "v"), do: {x, 0}
  defp next(map, {x, y}, ">") when is_map_key(map, {x + 1, y}), do: {x + 1, y}
  defp next(_, {_, y}, ">"), do: {0, y}

  @doc """
  ## Examples
      iex> sample() |> part_2()
      sample()

      iex> input() |> part_2()
      input()
  """
  def part_2(input) do
    input
  end
end
