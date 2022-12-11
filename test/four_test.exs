defmodule FourTest do
  use ExUnit.Case
  import Four

  @data """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 2
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 4
  end

  test "solves the first stage" do
    assert solve() == 599
  end

  test "solves the second stage" do
    assert solve2() == 928
  end
end
