defmodule SixTest do
  use ExUnit.Case
  import Six

  @data """
  mjqjpqmgbljsphdztnvjfqwrcgsmlb
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 7
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 19
  end


  test "solves the first stage" do
    assert solve() == 1816
  end

  test "solves the second stage" do
    assert solve2() == 2625
  end
end
