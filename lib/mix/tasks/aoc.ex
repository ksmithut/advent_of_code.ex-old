defmodule Mix.Tasks.Aoc do
  use Mix.Task

  def run(args) do
    {year, day, part} = parse_args!(args)

    case AdventOfCode.run_part(year, day, part) do
      {:ok, value} -> if is_binary(value), do: IO.puts(value), else: IO.inspect(value)
      {:error, reason} -> IO.warn(reason)
    end
  end

  def current_year() do
    %{year: year, month: month} = Date.utc_today()

    case month do
      12 -> year
      11 -> year
      _ -> year - 1
    end
  end

  def parse_args!(args) do
    switches = [year: :integer, day: :integer, part: :integer]
    aliases = [y: :year, d: :day, p: :part]

    opts =
      case OptionParser.parse(args, aliases: aliases, strict: switches) do
        {opts, [], []} -> opts
        {_, [], any} -> Mix.raise("Invalid option(s): #{inspect(any)}")
        {_, any, _} -> Mix.raise("Unexpected argument(s): #{inspect(any)}")
      end

    {opts[:year] || current_year(), opts[:day] || 1, opts[:part] || 1}
  end
end
