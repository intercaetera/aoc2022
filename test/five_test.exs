defmodule FiveTest do
  use ExUnit.Case
  import Five

  @data """
      [D]    
  [N] [C]    
  [Z] [M] [P]
   1   2   3 

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == "CMZ"
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == "MCD"
  end


  test "solves the first stage" do
    assert solve() == "TQRFCBSJJ"
  end

  test "solves the second stage" do
    assert solve2() == "RMHFJNVFP"
  end
end
