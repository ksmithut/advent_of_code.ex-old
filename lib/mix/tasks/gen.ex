defmodule Mix.Tasks.Gen do
  use Mix.Task
  import Mix.Tasks.Aoc, only: [parse_args!: 1]

  def run(args) do
    {year, day, _} = parse_args!(args)
    AdventOfCode.generate(year, day)
  end
end
