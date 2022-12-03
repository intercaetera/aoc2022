defmodule TwoTest do
  use ExUnit.Case
  import Two

  @data """
  A Y
  B X
  C Z
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 15
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 12
  end


  test "solves the first stage correctly" do
    assert Two.solve() == 14827
  end

  test "solves the second stage correctly" do
    assert Two.solve2() == 13889
  end
end
