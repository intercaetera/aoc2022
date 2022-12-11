defmodule NineTest do
  use ExUnit.Case
  import Nine

  @data1 """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  @data2 """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
  """

  test "solves the first test case" do
    assert prep(@data1) |> solve() == 13
  end

  test "solves the second test case" do
    assert prep(@data2) |> solve2() == 36
  end

  test "solves the first stage" do
    assert solve() == 6314
  end

  test "solves the second stage" do
    assert solve2() == 2504
  end
end
