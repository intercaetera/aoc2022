defmodule Three do
  @filepath "./lib/inputs/three.txt"

  @uppercase_offset -38 # ascii(A) = 65
  @lowercase_offset -96 # ascii(a) = 97

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
  end

  # Part 1
  def solve(source \\ prep()) do
    source
    |> Enum.map(&split_compartments/1)
    |> Enum.map(&find_duplicate/1)
    |> Enum.map(&get_item_priority/1)
    |> Enum.sum()
  end

  defp split_compartments(rucksack) do
    offset = String.length(rucksack) / 2 |> Kernel.floor()
    rucksack |> String.split_at(offset) |> Tuple.to_list()
  end

  defp find_duplicate([first | rest]) do
    first
    |> String.graphemes()
    |> Enum.find(nil, fn c -> 
      Enum.all?(rest, fn cs ->
        String.contains?(cs, c)
      end)
    end)
  end

  defp get_item_priority(item) do
    char = item |> String.to_charlist() |> hd()
    cond do
      char in ?a..?z -> char + @lowercase_offset
      char in ?A..?Z -> char + @uppercase_offset
    end
  end

  # Part 2
  def solve2(source \\ prep()) do
    source
    |> Enum.chunk_every(3)
    |> Enum.map(&find_duplicate/1)
    |> Enum.map(&get_item_priority/1)
    |> Enum.sum()
  end
end
