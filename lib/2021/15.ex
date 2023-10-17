import AdventOfCode

advent_of_code 2021, 15 do
  @moduledoc """
  https://adventofcode.com/2021/day/15
  https://adventofcode.com/2021/day/15/input
  """
  def sample() do
    """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """
  end

  defp parse_input(input) do
    input
    |> String.split()
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(&Integer.digits/1)
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line |> Stream.with_index() |> Stream.map(fn {val, x} -> {{x, y}, val} end)
    end)
    |> Map.new()
  end

  @doc """
  ## Examples
      # iex> sample() |> part_1()
      # 40

      # iex> input() |> part_1()
      # 403
  """
  def part_1(input) do
    grid = parse_input(input)
    start = {0, 0}
    finish = grid |> Map.keys() |> Enum.max_by(fn {x, y} -> x + y end)

    grid |> grid_to_graph() |> dijkstra(start, finish)
  end

  defp grid_to_graph(grid) do
    grid
    |> Map.keys()
    |> Enum.map(fn pos ->
      pos
      |> neighbors()
      |> Enum.filter(&Map.has_key?(grid, &1))
      |> Enum.map(fn pos -> {pos, Map.fetch!(grid, pos)} end)
      |> (&{pos, &1}).()
    end)
    |> Map.new()
  end

  def dijkstra(graph, start, finish) do
    distances =
      graph |> Map.keys() |> Enum.map(&{&1, :infinity}) |> Map.new() |> Map.put(start, 0)

    queue = Map.keys(graph)

    graph
    |> search(queue, distances)
    |> Map.get(finish)
  end

  defp search(_graph, [], distances), do: distances

  defp search(graph, queue, distances) do
    smallest = Enum.min_by(queue, &Map.get(distances, &1))
    queue = List.delete(queue, smallest)

    distances =
      graph
      |> Map.get(smallest)
      |> Enum.reduce(distances, fn
        {key, value}, distances ->
          if distances[key] > distances[smallest] + value,
            do: Map.put(distances, key, distances[smallest] + value),
            else: distances
      end)

    search(graph, queue, distances)
  end

  defp neighbors({x, y}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

  @doc """
  ## Examples
      # iex> sample() |> part_2()
      # 315

      # iex> input() |> part_2()
      # input()
  """
  def part_2(input) do
    grid = parse_input(input) |> expand_grid()
    start = {0, 0}
    finish = grid |> Map.keys() |> Enum.max_by(fn {x, y} -> x + y end)

    grid |> grid_to_graph() |> dijkstra(start, finish)
  end

  defp expand_grid(grid) do
    {width, height} = grid |> Map.keys() |> Enum.max_by(fn {x, y} -> x + y end)
    width = width + 1
    height = height + 1

    for x <- 0..4, y <- 0..4, {{kx, ky}, value} <- Map.to_list(grid), into: %{} do
      {{x * width + kx, y * height + ky}, increment_digit(value, x + y)}
    end
  end

  defp increment_digit(9), do: 1
  defp increment_digit(val), do: val + 1
  defp increment_digit(val, 0), do: val
  defp increment_digit(val, times), do: val |> increment_digit() |> increment_digit(times - 1)
end
