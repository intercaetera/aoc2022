defmodule Nine do
  @filepath "./lib/inputs/nine.txt"

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.flat_map(fn row ->
      [dir, count] = String.split(row, " ")
      List.duplicate(String.to_atom(dir), String.to_integer(count))
    end)
  end

  # Part 1
  def solve(source \\ prep()) do
    simulate(source, [{{0, 0}, {0, 0}}])
    |> Enum.map(fn {_, tail} -> tail end)
    |> Enum.uniq()
    |> length
  end

  def simulate([], positions), do: positions

  def simulate([move | tail], [position | positions]) do
    new_position = simulate_move(position, move)
    simulate(tail, [new_position, position] ++ positions)
  end

  def simulate_move({head, tail}, move) do
    new_head = get_next_position(head, move)
    new_tail = simulate_tail_move({new_head, tail})

    {new_head, new_tail}
  end

  def simulate_tail_move({head, tail}) do
    offset = get_offset(head, tail)
    tail_move = get_moves_for_offset(offset)
    get_next_position(tail, tail_move)
  end

  def get_next_position({x, y}, move) do
    case move do
      :S -> {x, y}
      :U -> {x, y + 1}
      :UR -> {x + 1, y + 1}
      :R -> {x + 1, y}
      :DR -> {x + 1, y - 1}
      :D -> {x, y - 1}
      :DL -> {x - 1, y - 1}
      :L -> {x - 1, y}
      :UL -> {x - 1, y + 1}
    end
  end

  def get_offset({hx, hy}, {tx, ty}), do: {tx - hx, ty - hy}

  def get_moves_for_offset({x, y}) do
    cond do
      # safe zone
      x <= 1 && x >= -1 && y <= 1 && y >= -1 -> :S
      # cardinals
      x == 0 && y > 0 -> :D
      y == 0 && x > 0 -> :L
      x == 0 && y < 0 -> :U
      y == 0 && x < 0 -> :R
      # diagonals
      x > 0 && y > 0 -> :DL
      x > 0 && y < 0 -> :UL
      x < 0 && y < 0 -> :UR
      x < 0 && y > 0 -> :DR
      true -> :error
    end
  end

  # Part 2
  def begin_simulating_long_move([head | tail], move) do
    new_head = get_next_position(head, move)
    simulate_long_move([new_head | tail], move, [new_head])
  end

  def simulate_long_move([head, next | tail], move, new_rope) do
    new_next = simulate_tail_move({head, next})
    simulate_long_move([new_next | tail], move, [new_next] ++ new_rope)
  end

  def simulate_long_move([_head | []], _, new_rope), do: new_rope |> Enum.reverse()

  def solve2(source \\ prep()) do
    rope = List.duplicate({0, 0}, 10)

    source
    |> Enum.reduce([rope], fn move, ropes ->
      [begin_simulating_long_move(hd(ropes), move) | ropes]
    end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> length()
  end
end
