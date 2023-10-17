import AdventOfCode

advent_of_code 2021, 7 do
  @moduledoc """
  https://adventofcode.com/2021/day/7
  https://adventofcode.com/2021/day/7/input
  """
  def sample(), do: "16,1,2,0,4,2,7,1,2,14"

  defp parse_input(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      37

      iex> input() |> part_1()
      325528
  """
  def part_1(input) do
    parse_input(input)
    |> least_fuel(fn from, to -> abs(from - to) end)
  end

  defp least_fuel(list, calculate) do
    {min, max} = Enum.min_max(list)

    min..max
    |> Enum.map(fn to ->
      Enum.reduce(list, 0, fn from, fuel -> fuel + calculate.(from, to) end)
    end)
    |> Enum.min()
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      168

      iex> input() |> part_2()
      85015836
  """
  def part_2(input) do
    parse_input(input)
    |> least_fuel(fn from, to -> Enum.sum(1..abs(from - to)) end)
  end
end
