defmodule Two do
  @filepath "./lib/inputs/two.txt"

  def read(path \\ @filepath) do
    File.read!(path)
  end

  def prep(content \\ read()) do
    content
    |> String.trim()
    |> String.split("\n")
  end

  # Part 1
  def solve(source \\ prep()) do
    source
    |> Enum.map(&parse_game/1)
    |> Enum.map(fn {you, me} -> get_points(you, me) end)
    |> Enum.sum()
  end

  defp parse_game(game) do
    [abc, xyz] = game |> String.split(" ")

    you =
      case abc,
        do:
          (
            "A" -> :rock
            "B" -> :paper
            "C" -> :scissors
          )

    me =
      case xyz,
        do:
          (
            "X" -> :rock
            "Y" -> :paper
            "Z" -> :scissors
          )

    {you, me}
  end

  defp get_choice_points(:rock), do: 1
  defp get_choice_points(:paper), do: 2
  defp get_choice_points(:scissors), do: 3

  defp get_game_points(:rock, :paper), do: 6
  defp get_game_points(:paper, :scissors), do: 6
  defp get_game_points(:scissors, :rock), do: 6
  defp get_game_points(you, you), do: 3
  defp get_game_points(_, _), do: 0

  defp get_points(you, me), do: get_game_points(you, me) + get_choice_points(me)

  # Part 2
  def solve2(source \\ prep()) do
    source
    |> Enum.map(&parse_game2/1)
    |> Enum.map(fn {you, outcome} -> get_points2(you, outcome) end)
    |> Enum.sum()
  end

  defp parse_game2(game) do
    [abc, xyz] = game |> String.split(" ")

    you =
      case abc,
        do:
          (
            "A" -> :rock
            "B" -> :paper
            "C" -> :scissors
          )

    outcome =
      case xyz,
        do:
          (
            "X" -> :loss
            "Y" -> :draw
            "Z" -> :win
          )

    {you, outcome}
  end

  defp outcomes(:rock), do: [win: :paper, draw: :rock, loss: :scissors]
  defp outcomes(:paper), do: [win: :scissors, draw: :paper, loss: :rock]
  defp outcomes(:scissors), do: [win: :rock, draw: :scissors, loss: :paper]

  defp get_points2(you, outcome) do
    me = outcomes(you) |> Keyword.get(outcome)
    get_points(you, me)
  end
end
