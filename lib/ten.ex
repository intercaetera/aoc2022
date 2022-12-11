defmodule Ten do
  @filepath "./lib/inputs/ten.txt"

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.scan([{1, 1}], fn line, acc ->
      {cycle, x} = List.last(acc)

      case line do
        "noop" -> [{cycle + 1, x}]
        "addx " <> n -> [{cycle + 1, x}, {cycle + 2, x + String.to_integer(n)}]
      end
    end)
    |> (fn l -> [{1, 1} | l] end).()
    |> List.flatten()
  end

  # Part 1
  def solve(source \\ prep()) do
    source
    |> Enum.filter(fn {count, _} -> rem(count, 40) == 20 end)
    |> Enum.map(fn {cycle, x} -> cycle * x end)
    |> Enum.sum()
  end

  # Part 2
  def sprite_visible?({cycle, x}) do
    position = rem(cycle - 1, 40)
    sprite = (x - 1)..(x + 1)
    position in sprite
  end

  def solve2(source \\ prep()) do
    source
    |> Enum.map(&sprite_visible?/1)
    |> Enum.map(fn
      true -> "#"
      false -> "."
    end)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
  end
end
