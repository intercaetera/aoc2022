defmodule ThreeTest do
  use ExUnit.Case
  import Three

  @data """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 24000
  end

  @tag :skip
  test "solves the second test case" do
    assert prep(@data) |> solve2() == 45000
  end


  @tag :skip
  test "solves the first stage" do
    assert solve() == 69912
  end

  @tag :skip
  test "solves the second stage" do
    assert solve2() == 208180
  end
end
