import AdventOfCode

advent_of_code 2021, 18 do
  @moduledoc """
  https://adventofcode.com/2021/day/18
  https://adventofcode.com/2021/day/18/input
  """

  def sample() do
    """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> to_pairs()
    |> elem(0)
  end

  defp to_pairs(["[" | rest]) do
    {left, ["," | rest]} = to_pairs(rest)
    {right, ["]" | rest]} = to_pairs(rest)
    {{left, right}, rest}
  end

  defp to_pairs([value | rest]), do: {String.to_integer(value), rest}

  @doc """
  ## Examples
      iex> sample() |> part_1()
      4140

      iex> input() |> part_1()
      2501
  """
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.reduce(fn right, left -> reduce({left, right}) end)
    |> mag()
  end

  defp reduce(pair), do: pair |> explode() |> reduce_inner()

  defp reduce_inner({false, pair, _, _}) do
    case split(pair) do
      {true, pair} -> reduce(pair)
      {_, pair} -> pair
    end
  end

  defp reduce_inner({_, pair, _, _}), do: reduce(pair)

  defp explode(pair, depth \\ 0)
  defp explode({left, right}, 4), do: {true, 0, left, right}

  defp explode({left, right}, depth) do
    case explode(left, depth + 1) do
      {false, left, _, _} ->
        case explode(right, depth + 1) do
          {true, right, a, b} when a > 0 -> {true, {inc(left, a, 1), right}, -1, b}
          {exploded, right, a, b} -> {exploded, {left, right}, a, b}
        end

      {true, left, a, b} when b > 0 ->
        {true, {left, inc(right, b, 0)}, a, -1}

      {true, left, a, b} ->
        {true, {left, right}, a, b}
    end
  end

  defp explode(x, _), do: {false, x, -1, -1}

  defp inc({left, right}, v, 0), do: {inc(left, v, 0), right}
  defp inc({left, right}, v, 1), do: {left, inc(right, v, 1)}
  defp inc(value, v, _), do: value + v

  defp split({left, right}) do
    case split(left) do
      {false, left} ->
        {did_split, right} = split(right)
        {did_split, {left, right}}

      {true, left} ->
        {true, {left, right}}
    end
  end

  defp split(value) when value < 10, do: {false, value}
  defp split(value), do: {true, {floor(value / 2), ceil(value / 2)}}

  defp mag({left, right}), do: 3 * mag(left) + 2 * mag(right)
  defp mag(value), do: value

  @doc """
  ## Examples
      iex> sample() |> part_2()
      3993

      iex> input() |> part_2()
      4935
  """
  def part_2(input) do
    input
    |> parse_input()
    |> combos()
    |> Enum.map(fn pair -> pair |> reduce() |> mag() end)
    |> Enum.max()
  end

  defp combos(list) do
    for left <- list, right <- list, left != right, do: {left, right}
  end
end
