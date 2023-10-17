import AdventOfCode

advent_of_code 2021, 21 do
  @moduledoc """
  https://adventofcode.com/2021/day/21
  https://adventofcode.com/2021/day/21/input
  """
  def sample() do
    """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/^Player \d starting position: /, ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&{&1, 0})
    |> List.to_tuple()
  end

  @doc """
  ## Examples
      iex> sample() |> part_1()
      739785

      iex> input() |> part_1()
      926610
  """
  def part_1(input) do
    input
    |> parse_input()
    |> practice_game()
  end

  defp practice_game(players, dice \\ 0, count \\ 0)
  defp practice_game({{_, score1}, {_, score2}}, _, count) when score2 >= 1000, do: score1 * count

  defp practice_game({{pos, score}, p2}, dice, count) do
    roll_1 = rem(dice, 100)
    roll_2 = rem(dice + 1, 100)
    roll_3 = rem(dice + 2, 100)
    dice = rem(dice + 3, 100)
    pos = rem(pos + roll_1 + roll_2 + roll_3 + 2, 10) + 1
    practice_game({p2, {pos, score + pos}}, dice, count + 3)
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      444356092776315

      iex> input() |> part_2()
      146854918035875
  """
  def part_2(input) do
    players = input |> parse_input()
    quantum_game({%{players => 1}, 0, 0})
  end

  def quantum_game({states, p1_wins, p2_wins}) when states == %{},
    do: max(p1_wins, p2_wins)

  def quantum_game({states, p1_wins, p2_wins}) do
    states
    |> Enum.reduce({%{}, p2_wins, p1_wins}, &split_3/2)
    |> quantum_game()
  end

  @quantum_movements %{
    6 => 7,
    5 => 6,
    7 => 6,
    4 => 3,
    8 => 3,
    3 => 1,
    9 => 1
  }

  def split_3({{{pos, score}, p2}, count}, state) do
    @quantum_movements
    |> Enum.map(fn {dice, final} ->
      new_pos = rem(pos + dice - 1, 10) + 1
      {{{new_pos, score + new_pos}, p2}, count * final}
    end)
    |> Enum.reduce(state, &next_state/2)
  end

  def next_state({{{_, score}, _}, count}, {states, p1_wins, p2_wins}) when score >= 21,
    do: {states, p1_wins + count, p2_wins}

  def next_state({{p1, p2}, c}, {states, p1_wins, p2_wins}) do
    {Map.update(states, {p2, p1}, c, &(&1 + c)), p1_wins, p2_wins}
  end
end
