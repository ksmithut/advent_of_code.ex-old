import AdventOfCode

advent_of_code 2021, 3 do
  @moduledoc """
  https://adventofcode.com/2021/day/3
  https://adventofcode.com/2021/day/3/input
  """
  def sample() do
    """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line), do: line |> String.graphemes() |> Enum.map(&String.to_integer/1)

  @doc """
  ## Examples
      iex> sample() |> part_1()
      198

      iex> input() |> part_1()
      2648450
  """
  def part_1(input) do
    input
    |> parse_input()
    |> transpose()
    |> rates()
  end

  defp transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp gamma_rates(lines) do
    Enum.map(lines, fn col -> (Enum.sum(col) / length(col)) |> round() end)
  end

  defp rates(lines) do
    gamma = gamma_rates(lines)
    epsilon = Enum.map(gamma, &flip_bit/1)
    to_int(gamma) * to_int(epsilon)
  end

  defp flip_bit(0), do: 1
  defp flip_bit(1), do: 0

  defp to_int(list), do: Enum.join(list, "") |> String.to_integer(2)

  @doc """
  ## Examples
      iex> sample() |> part_2()
      230

      iex> input() |> part_2()
      2845944
  """
  def part_2(input) do
    input
    |> parse_input()
    |> part_2_rates()
  end

  defp part_2_rates(lines) do
    find_rating_by(lines, &most_common/1) * find_rating_by(lines, &least_common/1)
  end

  defp find_rating_by(lines, func) do
    lines
    |> Enum.with_index(fn _, index -> index end)
    |> Enum.reduce_while(lines, fn
      _, [line] ->
        {:halt, line}

      index, lines ->
        char = Enum.frequencies_by(lines, &Enum.at(&1, index)) |> func.()
        lines = Enum.filter(lines, fn line -> Enum.at(line, index) === char end)
        {:cont, lines}
    end)
    |> to_int()
  end

  defp most_common(%{0 => zero, 1 => one}) when zero > one, do: 0
  defp most_common(%{1 => _}), do: 1
  defp most_common(_), do: 0

  defp least_common(%{0 => zero, 1 => one}) when zero > one, do: 1
  defp least_common(%{0 => _}), do: 0
  defp least_common(_), do: 1
end
