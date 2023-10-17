import AdventOfCode

advent_of_code 2021, 14 do
  @moduledoc """
  https://adventofcode.com/2021/day/14
  https://adventofcode.com/2021/day/14/input
  """
  def sample() do
    """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
  end

  defp parse_input(input) do
    [template, rules] = input |> String.trim() |> String.split("\n\n")

    pairs =
      template
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(%{}, fn [a, b], map -> Map.update(map, a <> b, 1, &(&1 + 1)) end)

    rules = rules |> String.split("\n") |> Enum.map(&parse_rule/1) |> Map.new()
    {template, pairs, rules}
  end

  defp parse_rule(line) do
    [a, _, b] = String.split(line)
    {a, b}
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      1588

      iex> input() |> part_1()
      2937
  """
  def part_1(input) do
    {template, pairs, rules} = parse_input(input)
    pairs |> step(rules, 10) |> calculate(template)
  end

  defp step(pairs, _, 0), do: pairs
  defp step(pairs, rules, times), do: pairs |> step(rules) |> step(rules, times - 1)

  defp step(pairs, rules) do
    Enum.reduce(pairs, %{}, fn
      {key, count}, pairs ->
        [a, b] = String.graphemes(key)
        c = rules[key]

        pairs
        |> Map.update(a <> c, count, &(&1 + count))
        |> Map.update(c <> b, count, &(&1 + count))
    end)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      2188189693529

      iex> input() |> part_2()
      3390034818249
  """
  def part_2(input) do
    {template, pairs, rules} = parse_input(input)
    pairs |> step(rules, 40) |> calculate(template)
  end

  defp calculate(pairs, template) do
    pairs
    |> count_characters()
    # First and last characters were not included in pairings, so at an extra
    # count for them
    |> Map.update!(String.at(template, 0), &(&1 + 1))
    |> Map.update!(String.at(template, -1), &(&1 + 1))
    |> Map.values()
    |> Enum.min_max()
    |> (fn {min, max} -> max - min end).()
    # Each character was included twice because each "character" is included in
    # two pairs
    |> div(2)
  end

  defp count_characters(pairs) do
    Enum.reduce(pairs, %{}, fn {key, count}, chars ->
      [a, b] = String.graphemes(key)

      chars
      |> Map.update(a, count, &(&1 + count))
      |> Map.update(b, count, &(&1 + count))
    end)
  end
end
