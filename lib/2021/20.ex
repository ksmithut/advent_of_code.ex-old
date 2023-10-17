import AdventOfCode

advent_of_code 2021, 20 do
  @moduledoc """
  https://adventofcode.com/2021/day/20
  https://adventofcode.com/2021/day/20/input
  """
  def sample() do
    """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    """
  end

  defp parse_input(input) do
    [algorithm, image] = input |> String.trim() |> String.split("\n\n")
    {parse_algorithm(algorithm), parse_image(image)}
  end

  defp parse_algorithm(algorithm) do
    algorithm
    |> String.graphemes()
    |> Enum.map(&char_to_bit/1)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> {i, x} end)
    |> Map.new()
  end

  defp parse_image(image) do
    image
    |> String.split()
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(&char_to_bit/1)
      |> Enum.with_index()
      |> Enum.map(fn {bit, x} -> {{x, y}, bit} end)
    end)
    |> Map.new()
  end

  defp char_to_bit("."), do: 0
  defp char_to_bit("#"), do: 1

  @doc """
  ## Examples
      iex> sample() |> part_1()
      35

      iex> input() |> part_1()
      5483
  """
  def part_1(input) do
    {algorithm, image} = parse_input(input)

    image
    |> enhance(algorithm, 2)
    |> Map.values()
    |> Enum.sum()
  end

  defp neighbors({x, y}), do: for(y1 <- (y - 1)..(y + 1), x1 <- (x - 1)..(x + 1), do: {x1, y1})

  defp enhance(image, _, 0), do: image

  defp enhance(image, algorithm, n) do
    {{min_x, min_y}, {max_x, max_y}} =
      image |> Map.keys() |> Enum.min_max_by(fn {x, y} -> x + y end)

    default_value = if rem(n, 2) == 0, do: 0, else: Map.get(algorithm, 0)

    for(x <- (min_x - 1)..(max_x + 1), y <- (min_y - 1)..(max_y + 1), do: {x, y})
    |> Enum.map(fn pos ->
      value =
        pos
        |> neighbors()
        |> Enum.map(&Map.get(image, &1, default_value))
        |> Integer.undigits(2)
        |> (&Map.get(algorithm, &1)).()

      {pos, value}
    end)
    |> Map.new()
    |> enhance(algorithm, n - 1)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      3351

      iex> input() |> part_2()
      18732
  """
  def part_2(input) do
    {algorithm, image} = parse_input(input)

    image
    |> enhance(algorithm, 50)
    |> Map.values()
    |> Enum.sum()
  end
end
