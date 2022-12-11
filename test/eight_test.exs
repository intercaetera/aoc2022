defmodule EightTest do
  use ExUnit.Case
  import Eight

  @data """
  30373
  25512
  65332
  33549
  35390
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 21
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 8
  end

  test "solves the first stage" do
    assert solve() == 1543
  end

  test "solves the second stage" do
    assert solve2() == 595_080
  end
end
