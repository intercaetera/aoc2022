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
    assert prep(@data) |> solve() == 157
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 70
  end


  test "solves the first stage" do
    assert solve() == 7737
  end

  test "solves the second stage" do
    assert solve2() == 2697
  end
end
