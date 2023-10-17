import AdventOfCode

advent_of_code 2021, 17 do
  @moduledoc """
  https://adventofcode.com/2021/day/17
  https://adventofcode.com/2021/day/17/input
  """
  def sample() do
    """
    target area: x=20..30, y=-10..-5
    """
  end

  @input_regex ~r/^target area: x=(?<x1>-?\d+)\.\.(?<x2>-?\d+), y=(?<y1>-?\d+)\.\.(?<y2>-?\d+)$/
  defp parse_input(input) do
    %{"x1" => x1, "x2" => x2, "y1" => y1, "y2" => y2} = Regex.named_captures(@input_regex, input)

    [x1, x2, y1, y2]
    |> Enum.map(&String.to_integer/1)
    |> (fn [x1, x2, y1, y2] -> {x1..x2, y1..y2} end).()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      45

      iex> input() |> part_1()
      3916
  """
  def part_1(input) do
    input
    |> parse_input()
    |> possible_trajectories()
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  defp possible_trajectories(target) do
    {x_range, y_range} = target
    target_set = for x <- x_range, y <- y_range, into: MapSet.new(), do: {x, y}

    target
    |> intercepts()
    |> Enum.map(&launch_probe(&1, target))
    |> Enum.filter(fn {_, path} ->
      Enum.any?(path, &MapSet.member?(target_set, &1))
    end)
  end

  defp intercepts({x1..x2, y1.._}) do
    # Equation for x is `v * (v + 1) / 2 = x`
    # https://www.symbolab.com/solver/step-by-step/solve%20for%20v%2C%20v%20%5Ccdot%20%5Cleft(v%20%2B%201%5Cright)%20%2F%202%20%3D%20x?or=input
    # turns into `(-1 +- :math.sqrt(1 + 8 * x)) / 2 = v`
    min_x = ceil((-1 + :math.sqrt(1 + 8 * x1)) / 2)
    for x <- min_x..x2, y <- y1..(-y1 - 1), do: {x, y}
  end

  defp run({{0, vy}, {x, y}}), do: {{0, vy - 1}, {x, y + vy}}
  defp run({{vx, vy}, {x, y}}), do: {{vx - 1, vy - 1}, {x + vx, y + vy}}

  defp launch_probe(velocity, target), do: launch_probe(velocity, velocity, target, [{0, 0}])

  defp launch_probe(start, velocity, {x1..x2, y1..y2} = target, path) do
    [{x, y} = pos | _] = path

    if x > max(x1, x2) or y < min(y1, y2) do
      {start, path}
    else
      {velocity, pos} = run({velocity, pos})
      launch_probe(start, velocity, target, [pos | path])
    end
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      112

      iex> input() |> part_2()
      2986
  """
  def part_2(input) do
    input
    |> parse_input()
    |> possible_trajectories()
    |> Enum.map(&elem(&1, 0))
    |> Enum.count()
  end
end
