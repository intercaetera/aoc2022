defmodule ElevenTest do
  use ExUnit.Case
  import Eleven

  @data """
  Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """

  test "solves the first test case" do
    assert prep(@data) |> solve() == 10605
  end

  test "solves the second test case" do
    assert prep(@data) |> solve2() == 2713310158
  end

  test "solves the first stage" do
    assert solve() == 113232
  end

  test "solves the second stage" do
    assert solve2() == 29703395016
  end
end
