defmodule Six do
  @filepath "./lib/inputs/six.txt"
  @length_start 4
  @length_message 14

  def read(path \\ @filepath) do
    File.read!(path)
  end

 # No prepping in this one
  def prep(content \\ read()), do: content

  # Part 1
  def solve(source \\ prep()) do
    {marker, rest} = String.split_at(source, @length_start)
    scan({ @length_start, marker, rest }, @length_start)
  end

  def scan({ index, marker, rest }, expected_length) do
    {char, new_rest} = String.split_at(rest, 1)
    {_, marker_tail} = String.split_at(marker, 1)
    new_marker = marker_tail <> char
    
    repeated? = new_marker
                |> String.graphemes()
                |> Enum.uniq()
                |> (fn l -> length(l) != expected_length end).()

    case repeated? do
      true -> scan({ index + 1, new_marker, new_rest }, expected_length)
      false -> index + 1
    end
  end

  # Part 2
  def solve2(source \\ prep()) do
    {marker, rest} = String.split_at(source, @length_message)
    scan({ @length_message, marker, rest }, @length_message)
  end
end
