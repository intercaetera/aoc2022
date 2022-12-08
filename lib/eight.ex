defmodule Eight do
  @filepath "./lib/inputs/eight.txt"

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    split_list = content |> String.trim() |> String.split("\n")

    height = length(split_list)
    width = String.length(hd(split_list))

    map = split_list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, map ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {tree_height, x}, map ->
        Map.put(map, {x, y}, String.to_integer(tree_height))
      end)
    end)

    {map, width, height}
  end

  # Part 1
  def solve(source \\ prep()) do
    {map, width, height} = source

    Map.to_list(map)
    |> Enum.map(fn {{x, y}, _} -> visible?({x, y}, map, {width, height}) end)
    |> Enum.count(&Function.identity/1)
  end

  defp get_viewing_distances({x, y}, map, {width, height}) do
    [
      Range.new((x-1), 0, -1) |> Enum.map(fn x -> Map.get(map, {x, y}) end), # Left
      Range.new((x+1), (width-1), 1) |> Enum.map(fn x -> Map.get(map, {x, y}) end), # Right
      Range.new((y-1), 0, -1) |> Enum.map(fn y -> Map.get(map, {x, y}) end), # Top
      Range.new((y+1), (height-1), 1) |> Enum.map(fn y -> Map.get(map, {x, y}) end), # Bottom
    ]
  end

  defp visible?(coords, map, dimensions) do
    tree_height = Map.get(map, coords)

    get_viewing_distances(coords, map, dimensions)
    |> Enum.map(fn dir -> Enum.all?(dir, fn h -> h < tree_height end) end)
    |> Enum.any?
  end

  # Part 2
  def solve2(source \\ prep()) do
    {map, width, height} = source

    Map.to_list(map)
    |> Enum.map(fn {{x, y}, _} -> get_scenic_score({x, y}, map, {width, height}) end)
    |> Enum.max()
  end

  def get_scenic_score(coords, map, dimensions) do
    tree_height = Map.get(map, coords)
    get_viewing_distances(coords, map, dimensions)
    |> Enum.map(fn side -> take_until(side, &(&1 >= tree_height)) end)
    |> Enum.reduce(fn a, b -> a * b end)
  end

  defp take_until(list, fun, count \\ 0)
  defp take_until([], _fun, count), do: count
  defp take_until([head | tail], fun, count) do
    case fun.(head) do
      false -> take_until(tail, fun, count + 1)
      true -> count + 1
    end
  end
end
