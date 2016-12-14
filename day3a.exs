defmodule Day3a do
    def run do
        File.read!('day3.txt')
        |> String.split
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk(3)
        |> Enum.count(&is_triangle?/1)
    end

    def is_triangle?(list) do
        [a, b, c] = Enum.sort list
        a + b > c
    end
end

IO.puts Day3a.run