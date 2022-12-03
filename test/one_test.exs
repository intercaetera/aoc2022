defmodule OneTest do
  use ExUnit.Case
  import One

  @data """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 24000
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 45000
  end


  test "solves the first stage" do
    assert solve() == 69912
  end

  test "solves the second stage" do
    assert solve2() == 208180
  end
end
