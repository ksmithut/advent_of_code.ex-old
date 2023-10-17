import AdventOfCode

advent_of_code 2021, 4 do
  @moduledoc """
  https://adventofcode.com/2021/day/4
  https://adventofcode.com/2021/day/4/input
  """
  def sample() do
    """
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    """
  end

  defp parse_input(input) do
    [drawn | bingo_boards] = String.split(input, "\n\n", trim: true)

    {
      drawn |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1),
      bingo_boards |> Enum.map(&parse_bingo_board/1)
    }
  end

  defp parse_bingo_board(bingo_board) do
    bingo_board
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      String.split(line)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        Map.put(map, String.to_integer(char), {x, y, false})
      end)
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      4512

      iex> input() |> part_1()
      46920
  """
  def part_1(input) do
    input
    |> parse_input()
    |> run()
  end

  defp run({drawn, boards}) do
    Enum.reduce_while(drawn, boards, &reduce_board/2)
  end

  defp reduce_board(num, boards) do
    boards = Enum.map(boards, &mark_board(&1, num))

    Enum.find_value(boards, fn board ->
      case bingo?(board) do
        true -> board
        _ -> false
      end
    end)
    |> case do
      nil ->
        {:cont, boards}

      board ->
        {:halt, calculate(board, num)}
    end
  end

  # defp print_board(board) do
  #   map =
  #     Enum.reduce(board, %{}, fn {val, {x, y, marked}}, map ->
  #       Map.put(map, {x, y}, {val, marked})
  #     end)

  #   Enum.map(0..4, fn y ->
  #     Enum.map(0..4, fn x ->
  #       {val, marked} = Map.get(map, {x, y})
  #       string = if marked, do: "#{to_string(val)}x", else: to_string(val)
  #       String.pad_leading(string, 3)
  #     end)
  #     |> Enum.join(" ")
  #   end)
  #   |> Enum.join("\n")
  # end

  defp calculate(board, num) do
    unmarked_sum =
      Enum.reduce(board, 0, fn
        {val, {_, _, false}}, total -> total + val
        _, total -> total
      end)

    unmarked_sum * num
  end

  defp mark_board(board, num) do
    case Map.get(board, num) do
      nil -> board
      {x, y, _} -> Map.put(board, num, {x, y, true})
    end
  end

  @winning [
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}],
    [{1, 0}, {1, 1}, {1, 2}, {1, 3}, {1, 4}],
    [{2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}],
    [{3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}],
    [{4, 0}, {4, 1}, {4, 2}, {4, 3}, {4, 4}],
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}],
    [{0, 1}, {1, 1}, {2, 1}, {3, 1}, {4, 1}],
    [{0, 2}, {1, 2}, {2, 2}, {3, 2}, {4, 2}],
    [{0, 3}, {1, 3}, {2, 3}, {3, 3}, {4, 3}],
    [{0, 4}, {1, 4}, {2, 4}, {3, 4}, {4, 4}]
  ]

  defp bingo?(board) do
    marked =
      Enum.reduce(board, MapSet.new(), fn
        {_, {x, y, true}}, set -> MapSet.put(set, {x, y})
        _, set -> set
      end)

    Enum.find_value(@winning, false, fn line ->
      Enum.all?(line, fn key -> MapSet.member?(marked, key) end)
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      1924

      iex> input() |> part_2()
      12635
  """
  def part_2(input) do
    input
    |> parse_input()
    |> run_2()
  end

  defp run_2({drawn, boards}) do
    Enum.reduce_while(drawn, boards, &reduce_board_2/2)
  end

  defp reduce_board_2(num, boards) do
    new_boards = Enum.map(boards, &mark_board(&1, num))

    Enum.reject(new_boards, &bingo?/1)
    |> case do
      [] ->
        {:halt, Enum.at(boards, 0) |> mark_board(num) |> calculate(num)}

      boards ->
        {:cont, boards}
    end
  end
end
