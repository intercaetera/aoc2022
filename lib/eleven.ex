defmodule Eleven do
  @filepath "./lib/inputs/eleven.txt"
  @rounds 20
  @rounds2 100

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&prep_monkey_string/1)
  end

  def prep_monkey_string(monkey_string) do
    [id, starting_items, operation, test, if_true, if_false] =
      monkey_string |> String.split("\n", trim: true)

    %{
      id: parse_id(id),
      items: parsed_starting_items(starting_items),
      operation: parse_operation(operation),
      test: parse_test(test),
      if_true: parse_if_true(if_true),
      if_false: parse_if_false(if_false),
      inspections: 0
    }
  end

  defp parse_id(id) do
    [_, parsed_id] = Regex.run(~r/Monkey (\d):/, id)
    String.to_integer(parsed_id)
  end

  def parsed_starting_items(starting_items) do
    [_, starting_items] = String.split(starting_items, "Starting items: ")
    starting_items |> String.split(", ") |> Enum.map(&String.to_integer/1)
  end

  def parse_operation(operation) do
    [_, operation] = String.split(operation, "Operation: new = ")
    [left, operator, right] = String.split(operation, " ")

    operation =
      case operator do
        "*" -> fn a, b -> a * b end
        "+" -> fn a, b -> a + b end
      end

    case {left, right} do
      {"old", "old"} -> fn x -> operation.(x, x) end
      {n, "old"} -> fn x -> operation.(String.to_integer(n), x) end
      {"old", n} -> fn x -> operation.(x, String.to_integer(n)) end
      _ -> :error
    end
  end

  def parse_test(test) do
    [_, test] = String.split(test, "Test: divisible by ")
    String.to_integer(test)
  end

  def parse_if_true(if_true) do
    [_, monkey] = String.split(if_true, "If true: throw to monkey ")
    String.to_integer(monkey)
  end

  def parse_if_false(if_false) do
    [_, monkey] = String.split(if_false, "If false: throw to monkey ")
    String.to_integer(monkey)
  end

  # Part 1
  def solve(monkeys \\ prep()) do
    Enum.reduce(
      1..@rounds,
      prepare_initial_state(monkeys),
      fn _, state -> simulate_round(state, monkeys, &calculate_worry_level/2) end
    )
    |> calculate_monkey_business()
  end

  def prepare_initial_state(monkeys) do
    Enum.map(monkeys, fn %{items: items, inspections: inspections} -> {items, inspections} end)
  end

  def calculate_monkey_business(state) do
    state
    |> Enum.map(fn {_, inspections} -> inspections end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def simulate_round(state, monkeys, calculate_worry_level) do
    Enum.reduce(
      Range.new(0, length(state) - 1),
      state,
      fn index, state -> simulate_turn(state, monkeys, index, calculate_worry_level) end
    )
  end

  def simulate_turn(state, monkeys, index, calculate_worry_level) do
    {items, inspections} = Enum.at(state, index)
    updated_monkey = {[], inspections + length(items)}

    current_monkey = Enum.at(monkeys, index)

    items_to_throw =
      items
      |> Enum.map(fn worry ->
        calculate_worry_level.(worry, current_monkey.operation)
        |> calculate_next_monkey(current_monkey)
      end)

    Enum.reduce(items_to_throw, state, fn {worry, new_monkey_index}, state ->
      List.update_at(state, new_monkey_index, fn {items, inspections} ->
        {items ++ [worry], inspections}
      end)
    end)
    |> List.update_at(index, fn _ -> updated_monkey end)
  end

  def calculate_worry_level(initial_worry, operation), do: operation.(initial_worry) |> div(3)

  def calculate_next_monkey(worry, %{test: test, if_true: if_true, if_false: if_false} = _monkey) do
    case rem(worry, test) === 0 do
      true -> {worry, if_true}
      false -> {worry, if_false}
    end
  end

  # Part 2
  def solve2(monkeys \\ prep()) do
    supermodulo = Enum.map(monkeys, fn m -> m.test end) |> Enum.product()
    calc_worry = fn worry, operation -> operation.(worry) |> rem(supermodulo) end

    Enum.reduce(
      1..10000,
      prepare_initial_state(monkeys),
      fn _, state -> simulate_round(state, monkeys, calc_worry) end
    )
    |> calculate_monkey_business()
  end
end
