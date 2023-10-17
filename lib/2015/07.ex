import AdventOfCode

advent_of_code 2015, 7 do
  use Bitwise, only_operators: true

  @moduledoc """
  https://adventofcode.com/2015/day/7
  https://adventofcode.com/2015/day/7/input
  """
  def sample() do
    """
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  @line_regex ~r/^([a-z0-9]+)? ?(AND|OR|LSHIFT|RSHIFT|NOT)? ?([a-z0-9]+)? -> ([a-z0-9]+)$/
  defp parse_line(line) do
    @line_regex
    |> Regex.run(line)
    |> case do
      [_, a, "AND", b, c] -> {c, {:and, parse_value(a), parse_value(b)}}
      [_, a, "OR", b, c] -> {c, {:or, parse_value(a), parse_value(b)}}
      [_, a, "LSHIFT", b, c] -> {c, {:lshift, parse_value(a), parse_value(b)}}
      [_, a, "RSHIFT", b, c] -> {c, {:rshift, parse_value(a), parse_value(b)}}
      [_, "", "NOT", b, c] -> {c, {:not, parse_value(b)}}
      [_, a, "", "", c] -> {c, {:assign, parse_value(a)}}
    end
  end

  defp parse_value(value) do
    case Integer.parse(value) do
      :error -> {:wire, value}
      {num, _} -> {:raw, num}
    end
  end

  @doc """
  ## Examples
      iex> sample() |> part_1("d")
      72

      iex> sample() |> part_1("e")
      507

      iex> sample() |> part_1("f")
      492

      iex> sample() |> part_1("g")
      114

      # iex> sample() |> part_1("h")
      # 65412

      # iex> sample() |> part_1("i")
      # 65079

      iex> sample() |> part_1("x")
      123

      iex> sample() |> part_1("y")
      456

      iex> input() |> part_1()
      956
  """
  def part_1(input, wire \\ "a") do
    input
    |> parse_input()
    |> resolve_wire({:wire, wire})
    |> elem(0)
  end

  defp resolve_wire(wires, wire, cache \\ %{})
  defp resolve_wire(_, {:raw, num}, cache), do: {num, cache}

  defp resolve_wire(_, {:wire, wire}, cache) when is_map_key(cache, wire),
    do: {cache[wire], cache}

  defp resolve_wire(wires, {:wire, wire}, cache) do
    wires
    |> Map.get(wire)
    |> case do
      {:and, a, b} ->
        {a_val, cache} = resolve_wire(wires, a, cache)
        {b_val, cache} = resolve_wire(wires, b, cache)
        value = a_val &&& b_val
        {value, Map.put(cache, wire, value)}

      {:or, a, b} ->
        {a_val, cache} = resolve_wire(wires, a, cache)
        {b_val, cache} = resolve_wire(wires, b, cache)
        value = a_val ||| b_val
        {value, Map.put(cache, wire, value)}

      {:lshift, a, b} ->
        {a_val, cache} = resolve_wire(wires, a, cache)
        {b_val, cache} = resolve_wire(wires, b, cache)
        value = a_val <<< b_val
        {value, Map.put(cache, wire, value)}

      {:rshift, a, b} ->
        {a_val, cache} = resolve_wire(wires, a, cache)
        {b_val, cache} = resolve_wire(wires, b, cache)
        value = a_val >>> b_val
        {value, Map.put(cache, wire, value)}

      {:not, a} ->
        {a_val, cache} = resolve_wire(wires, a, cache)
        value = ~~~a_val
        {value, Map.put(cache, wire, value)}

      {:assign, a} ->
        {value, cache} = resolve_wire(wires, a, cache)
        {value, Map.put(cache, wire, value)}
    end
  end

  @doc """
  ## Examples
      iex> input() |> part_2()
      40149
  """
  def part_2(input) do
    input
    |> parse_input()
    |> Map.put("b", {:assign, {:raw, part_1(input)}})
    |> resolve_wire({:wire, "a"})
    |> elem(0)
  end
end
