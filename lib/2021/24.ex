import AdventOfCode

advent_of_code 2021, 24 do
  @moduledoc """
  https://adventofcode.com/2021/day/24
  https://adventofcode.com/2021/day/24/input
  """
  def sample() do
    """
    inp w
    mul x 0
    add x z
    mod x 26
    div z 1
    add x 12
    eql x w
    eql x 0
    mul y 0
    add y 25
    mul y x
    add y 1
    mul z y
    mul y 0
    add y w
    add y 4
    mul y x
    add z y
    """
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.chunk_while(
      [],
      fn
        {"inp", _} = ins, [] -> {:cont, [ins]}
        {"inp", _} = ins, chunk -> {:cont, Enum.reverse(chunk), [ins]}
        ins, chunk -> {:cont, [ins | chunk]}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, Enum.reverse(acc), []}
      end
    )
  end

  defp parse_line(line) do
    case String.split(line) do
      [command, var] -> {command, var}
      [command, var, value] -> {command, var, parse_value(value)}
    end
  end

  defp parse_value(value) do
    case Integer.parse(value) do
      :error -> {:ref, value}
      {num, _} -> {:raw, num}
    end
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      sample()

      # iex> input() |> part_1()
      # input()
  """
  def part_1(input) do
    input
    |> parse_input()
    |> acl([%{}])
  end

  defp acl([], registers), do: registers

  defp acl([block | blocks], registers) do
    IO.inspect(length(registers))

    registers =
      for(digit <- 1..9, register <- registers, do: {run(register, block, digit), digit})
      |> Enum.group_by(fn {registers, _} -> Map.delete(registers, "w") end, &elem(&1, 1))

    acl(blocks, Map.keys(registers))
  end

  defp run(r, [], _), do: r

  defp run(r, [instruction | instructions], input),
    do: run(r, instruction, input) |> run(instructions, input)

  defp run(r, {"inp", a}, input), do: Map.put(r, a, input)
  defp run(r, {"add", a, b}, _), do: Map.put(r, a, Map.get(r, a, 0) + resolve(r, b))
  defp run(r, {"mul", a, b}, _), do: Map.put(r, a, Map.get(r, a, 0) * resolve(r, b))
  defp run(r, {"div", a, b}, _), do: Map.put(r, a, div(Map.get(r, a, 0), resolve(r, b)))
  defp run(r, {"mod", a, b}, _), do: Map.put(r, a, rem(Map.get(r, a, 0), resolve(r, b)))

  defp run(r, {"eql", a, b}, _),
    do: Map.put(r, a, if(Map.get(r, a, 0) == resolve(r, b), do: 1, else: 0))

  defp resolve(_, {:raw, value}), do: value
  defp resolve(registers, {:ref, key}), do: Map.get(registers, key, 0)

  @doc """
  ## Examples
      iex> sample() |> part_2()
      sample()

      iex> input() |> part_2()
      input()
  """
  def part_2(input) do
    input
  end
end
