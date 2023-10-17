import AdventOfCode

advent_of_code 2021, 10 do
  @moduledoc """
  https://adventofcode.com/2021/day/10
  https://adventofcode.com/2021/day/10/input
  """
  def sample() do
    """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      26397

      iex> input() |> part_1()
      290691
  """
  def part_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1))
    |> Enum.filter(&corrupt?/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end)
    |> Enum.sum()
  end

  defp parse_line(string, stack \\ [])
  defp parse_line("", stack), do: stack
  defp parse_line("(" <> rest, stack), do: parse_line(rest, [")" | stack])
  defp parse_line(")" <> rest, [")" | stack]), do: parse_line(rest, stack)
  defp parse_line("[" <> rest, stack), do: parse_line(rest, ["]" | stack])
  defp parse_line("]" <> rest, ["]" | stack]), do: parse_line(rest, stack)
  defp parse_line("{" <> rest, stack), do: parse_line(rest, ["}" | stack])
  defp parse_line("}" <> rest, ["}" | stack]), do: parse_line(rest, stack)
  defp parse_line("<" <> rest, stack), do: parse_line(rest, [">" | stack])
  defp parse_line(">" <> rest, [">" | stack]), do: parse_line(rest, stack)
  defp parse_line(<<char::bytes-size(1)>> <> _, _), do: {:corrupt, char}

  defp corrupt?({:corrupt, _}), do: true
  defp corrupt?(_), do: false

  @doc """
  ## Examples
      iex> sample() |> part_2()
      288957

      iex> input() |> part_2()
      2768166558
  """
  def part_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1))
    |> Enum.reject(&corrupt?/1)
    |> Enum.map(&calculate_points(&1))
    |> Enum.sort()
    |> middle()
  end

  defp calculate_points(stack, points \\ 0)
  defp calculate_points([], points), do: points
  defp calculate_points([")" | rest], points), do: calculate_points(rest, points * 5 + 1)
  defp calculate_points(["]" | rest], points), do: calculate_points(rest, points * 5 + 2)
  defp calculate_points(["}" | rest], points), do: calculate_points(rest, points * 5 + 3)
  defp calculate_points([">" | rest], points), do: calculate_points(rest, points * 5 + 4)

  defp middle(list), do: Enum.at(list, floor(length(list) / 2))
end
