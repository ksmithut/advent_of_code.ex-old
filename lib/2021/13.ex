import AdventOfCode

advent_of_code 2021, 13 do
  @moduledoc """
  https://adventofcode.com/2021/day/13
  https://adventofcode.com/2021/day/13/input
  """

  def sample() do
    """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
  end

  defp parse_input(input) do
    [top, folds] = input |> String.trim() |> String.split("\n\n")

    points =
      top
      |> String.split()
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    folds =
      folds
      |> String.split("\n", trim: true)
      |> Enum.map(fn "fold along " <> axis ->
        axis
        |> String.split("=")
        |> case do
          ["x", val] -> {:x, String.to_integer(val)}
          ["y", val] -> {:y, String.to_integer(val)}
        end
      end)

    {points, folds}
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      17

      iex> input() |> part_1()
      790
  """
  def part_1(input) do
    {points, folds} = parse_input(input)
    set = MapSet.new(points)

    folds
    |> Enum.take(1)
    |> Enum.reduce(set, &fold/2)
    |> MapSet.size()
  end

  defp fold({:x, fold}, set) do
    to_move = set |> Enum.filter(fn {x, _} -> x > fold end) |> MapSet.new()
    folded = to_move |> Enum.map(fn {x, y} -> {fold - (x - fold), y} end) |> MapSet.new()
    set |> MapSet.difference(to_move) |> MapSet.union(folded)
  end

  defp fold({:y, fold}, set) do
    to_move = set |> Enum.filter(fn {_, y} -> y > fold end) |> MapSet.new()
    folded = to_move |> Enum.map(fn {x, y} -> {x, fold - (y - fold)} end) |> MapSet.new()
    set |> MapSet.difference(to_move) |> MapSet.union(folded)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      \"""
      #####
      #...#
      #...#
      #...#
      #####
      \"""

      iex> input() |> part_2()
      \"""
      ###...##..#..#.####.###..####...##..##.
      #..#.#..#.#..#....#.#..#.#.......#.#..#
      #..#.#....####...#..###..###.....#.#...
      ###..#.##.#..#..#...#..#.#.......#.#...
      #....#..#.#..#.#....#..#.#....#..#.#..#
      #.....###.#..#.####.###..#.....##...##.
      \"""
  """
  def part_2(input) do
    {points, folds} = parse_input(input)
    set = MapSet.new(points)

    folds
    |> Enum.reduce(set, &fold/2)
    |> render()
  end

  defp render(set) do
    {x, _} = Enum.max_by(set, &elem(&1, 0))
    {_, y} = Enum.max_by(set, &elem(&1, 1))

    Enum.map(0..y, fn y ->
      Enum.map(0..x, fn x ->
        if MapSet.member?(set, {x, y}), do: "#", else: "."
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> (&(&1 <> "\n")).()
  end
end
