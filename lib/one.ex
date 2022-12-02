defmodule One do
  @filepath "./lib/inputs/one.txt"

  def prep do
    {:ok, content} = File.read(@filepath)
    content
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&split_as_ints/1)
  end

  defp split_as_ints(array) do
    array |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end

  # Part 1
  def solve(source) do
    source
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
  end

  # Part 2
  def solve2(source) do
    source
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
