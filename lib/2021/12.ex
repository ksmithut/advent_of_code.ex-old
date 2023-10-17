import AdventOfCode

advent_of_code 2021, 12 do
  @moduledoc """
  https://adventofcode.com/2021/day/12
  https://adventofcode.com/2021/day/12/input
  """
  def sample() do
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """
  end

  def sample_2() do
    """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """
  end

  def sample_3() do
    """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """
  end

  defp map_push(map, key, val), do: map |> Map.put_new(key, []) |> Map.update!(key, &[val | &1])

  defp type("start"), do: :start
  defp type("end"), do: :end
  defp type(val), do: if(val == String.upcase(val), do: :big, else: :small)

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      line |> String.split("-") |> Enum.map(&{type(&1), &1}) |> List.to_tuple()
    end)
    |> Enum.reduce(%{}, fn {a, b}, map -> map_push(map, a, b) |> map_push(b, a) end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      10

      iex> sample_2() |> part_1()
      19

      iex> sample_3() |> part_1()
      226

      iex> input() |> part_1()
      4104
  """
  def part_1(input) do
    input
    |> parse_input()
    |> find_paths({:start, "start"}, [], &can_move_small_once/2)
    |> length()
  end

  defp can_move_small_once({:start, "start"}, _), do: false
  defp can_move_small_once({:big, _}, _), do: true
  defp can_move_small_once({:end, "end"}, _), do: true
  defp can_move_small_once({:small, _} = node, path), do: !Enum.member?(path, node)

  defp find_paths(_, {:end, "end"}, path, _), do: [[{:end, "end"} | path]]

  defp find_paths(map, node, path, can_move) do
    map
    |> Map.get(node)
    |> Enum.filter(&can_move.(&1, path))
    |> Enum.flat_map(fn neighbor ->
      find_paths(map, neighbor, [neighbor | path], can_move)
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      36

      iex> sample_2() |> part_2()
      103

      iex> sample_3() |> part_2()
      3509

      iex> input() |> part_2()
      119760
  """
  def part_2(input) do
    input
    |> parse_input()
    |> find_paths({:start, "start"}, [], &can_move_small_twice/2)
    |> length()
  end

  defp can_move_small_twice({:start, "start"}, _), do: false
  defp can_move_small_twice({:big, _}, _), do: true
  defp can_move_small_twice({:end, "end"}, _), do: true

  defp can_move_small_twice({:small, _} = node, path) do
    if !Enum.member?(path, node) do
      true
    else
      path
      |> Enum.filter(fn
        {:small, _} -> true
        _ -> false
      end)
      |> Enum.frequencies_by(&elem(&1, 1))
      |> Map.values()
      |> Enum.all?(&(&1 < 2))
    end
  end
end
