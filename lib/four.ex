defmodule Four do
  @filepath './lib/inputs/four.txt'

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&split_into_ranges/1)
  end

  # Part 1
  def solve(source \\ prep()) do
    source
    |> Enum.map(fn [a, b] -> range_members?(a, b) end)
    |> Enum.count(&Function.identity/1)
  end

  defp split_into_ranges(line) do
    #a-b,x-y

    line
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [a, z] -> Range.new(String.to_integer(a), String.to_integer(z)) end)
  end

  defp range_members?(first, second, strategy \\ &Enum.all?/2) do
    first |> strategy.(fn x -> Enum.member?(second, x) end)
    || second |> strategy.(fn y -> Enum.member?(first, y) end) 
  end

  # Part 2
  def solve2(source \\ prep()) do
    source
    |> Enum.map(fn [a, b] -> range_members?(a, b, &Enum.any?/2) end)
    |> Enum.count(&Function.identity/1)
  end
end
