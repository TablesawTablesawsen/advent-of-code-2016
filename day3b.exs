defmodule Day3b do
    def run do
        File.read!('/home/tablesaw/erlang/elixir/advent/day3.txt')
        |> String.split
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk(3)
        |> List.zip
        |> Enum.flat_map(&Tuple.to_list/1)
        |> Enum.chunk(3)
        |> Enum.count(&is_triangle?/1)
    end

    def is_triangle?(list) do
        [a, b, c] = Enum.sort list
        a + b > c
    end
end

IO.puts Day3b.run