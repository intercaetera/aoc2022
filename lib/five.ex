defmodule Five do
  @filepath "./lib/inputs/five.txt"

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    [crates, moves] =
      content
      |> String.split("\n\n")

    parsed_crates =
      crates
      |> fill_empty()
      |> remove_unnecessary_characters()
      |> String.split("\n")
      |> Enum.drop(-1)
      |> get_crate_stacks()

    parsed_moves =
      moves
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_move/1)

    {parsed_crates, parsed_moves}
  end

  # Crate parsing
  defp fill_empty(crates) do
    start_rest = crates |> String.split("    ", parts: 2)

    case start_rest do
      [start, rest] -> fill_empty(start <> " [x]" <> rest)
      [start] -> start
    end
  end

  defp remove_unnecessary_characters(str) do
    str |> String.replace(~r/\[|\]|\ /, "")
  end

  defp get_crate_stacks(crates) do
    len =
      crates
      |> Enum.max_by(&String.length/1)
      |> String.length()
      |> Kernel.-(1)

    0..len
    |> Enum.map(fn i ->
      Enum.flat_map(crates, fn str -> String.at(str, i) |> parse_crate() end)
    end)
  end

  defp parse_crate("x"), do: []
  defp parse_crate(s), do: [s]

  # Move parsing
  defp parse_move(move) do
    [amount, from, to] =
      Regex.run(~r/move (\d*) from (\d*) to (\d*)/, move)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    [amount: amount, from: from, to: to]
  end

  # Part 1
  def solve(source \\ prep()), do: simulate(source, &Enum.reverse/1)

  def simulate(source, move_strategy \\ &Function.identity/1) do
    {crates, moves} = source

    moves
    |> Enum.reduce(crates, fn m, state -> move(m, state, move_strategy) end)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  defp move([amount: amount, from: from_column, to: to_column], state, move_strategy) do
    [from, to] = [from_column, to_column] |> Enum.map(fn n -> n - 1 end)

    crates = state |> Enum.at(from) |> Enum.take(amount) |> move_strategy.()

    state
    |> List.update_at(from, fn l -> Enum.drop(l, amount) end)
    |> List.update_at(to, fn l -> crates ++ l end)
  end

  # Part 2
  def solve2(source \\ prep()), do: simulate(source)
end
