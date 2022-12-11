defmodule SevenTest do
  use ExUnit.Case
  import Seven

  @data """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 95437
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 24_933_642
  end

  test "solves the first stage" do
    assert solve() == 1_583_951
  end

  test "solves the second stage" do
    assert solve2() == 214_171
  end
end
