defmodule Seven do
  @filepath "./lib/inputs/seven.txt"
  @max_size 100_000
  @filesystem 70_000_000
  @update_size 30_000_000

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
    |> parse_command(%{}, [])
    |> Map.to_list()
    |> flatten_tree()
  end

  def parse_command([], tree, _), do: tree

  def parse_command([head | tail], tree, pwd) do
    case head do
      "$ cd /" -> parse_command(tail, tree, ["/"])
      "$ cd .." -> parse_command(tail, tree, tl(pwd))
      "$ cd " <> dir -> parse_command(tail, tree, [dir | pwd])
      "$ ls" -> parse_ls(tail, tree, pwd)
    end
  end

  def parse_ls([], tree, pwd), do: parse_command([], tree, pwd)

  def parse_ls([head | tail], tree, pwd) do
    case head do
      "$" <> _ ->
        parse_command([head | tail], tree, pwd)

      "dir " <> _dir ->
        parse_ls(tail, tree, pwd)

      size_and_name ->
        [size, filename] = String.split(size_and_name, " ")
        tuple = {filename, String.to_integer(size)}
        new_tree = tree |> Map.update(pwd, [tuple], fn existing -> [tuple | existing] end)
        parse_ls(tail, new_tree, pwd)
    end
  end

  def flatten_tree(tree, flat \\ %{})
  def flatten_tree([], flat), do: flat

  def flatten_tree([head | tail], flat) do
    {path, files} = head
    total_size = files |> Enum.map(fn {_, size} -> size end) |> Enum.sum()

    new_flat =
      groups(path)
      |> Enum.reduce(flat, fn path, flat ->
        Map.update(flat, path, total_size, &(&1 + total_size))
      end)

    flatten_tree(tail, new_flat)
  end

  def groups([one]), do: [[one]]
  def groups([_head | tail] = list), do: [list | groups(tail)]

  # Part 1
  def solve(source \\ prep()) do
    source
    |> Map.to_list()
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.reject(fn size -> size >= @max_size end)
    |> Enum.sum()
  end

  # Part 2
  def solve2(source \\ prep()) do
    space_taken_up = Map.get(source, ["/"])
    free_space = @filesystem - space_taken_up
    space_to_free_up = @update_size - free_space

    source
    |> Map.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(fn size -> size > space_to_free_up end)
    |> Enum.sort(:asc)
    |> hd()
  end
end
