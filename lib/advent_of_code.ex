defmodule AdventOfCode do
  defp pad_day(day), do: day |> to_string() |> String.pad_leading(2, "0")

  def module_name(year, day) do
    mod_year = "Y#{year}" |> String.to_atom()
    mod_day = day |> pad_day() |> (&"D#{&1}").() |> String.to_atom()
    Module.concat(mod_year, mod_day)
  end

  defp input_path(year, day), do: "input/#{year}/#{pad_day(day)}.txt"
  defp code_path(year, day), do: "lib/#{year}/#{pad_day(day)}.ex"

  def input_string(year, day), do: input_path(year, day) |> File.read!()

  def input_stream(year, day),
    do: input_path(year, day) |> File.stream!() |> Stream.map(&String.trim/1)

  defmacro advent_of_code(year, day, do: body) do
    quote do
      defmodule unquote(module_name(year, day)) do
        use unquote(__MODULE__), year: unquote(year), day: unquote(day)

        unquote(body)
      end
    end
  end

  defmacro __using__(opts) do
    day = Keyword.fetch!(opts, :day)
    year = Keyword.fetch!(opts, :year)

    quote do
      def input, do: unquote(__MODULE__).input_string(unquote(year), unquote(day))

      defoverridable input: 0
    end
  end

  @moduledoc """
  Documentation for AdventOfCode.
  """
  def run_part(year, day, part) do
    module = module_name(year, day)
    input = input_string(year, day)

    case part do
      1 -> {:ok, module.part_1(input)}
      2 -> {:ok, module.part_2(input)}
      _ -> {:error, "No such part_#{part}"}
    end
  end

  @template EEx.compile_file("lib/template.eex")

  def generate(year, day) do
    {code, _} = Code.eval_quoted(@template, year: year, day: day)
    code_path(year, day) |> create_file(code)
    input_path(year, day) |> create_file()
  end

  defp create_file(path, contents \\ "") do
    :ok = File.mkdir_p!(Path.dirname(path))

    case File.exists?(path) do
      true ->
        IO.warn("File already exists at #{path}")

      _ ->
        :ok = File.write!(path, contents)
        IO.puts("Generated #{path}")
    end
  end
end
