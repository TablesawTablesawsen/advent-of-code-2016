defmodule Day6 do
    def run do
        File.read!('day6.txt')
        |> String.split
        |> Enum.map(&String.graphemes/1)
        |> List.zip
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&most_common_letter/1)
        |> Enum.join
    end

    def most_common_letter(list) do
        list
        |> Enum.sort
        |> Enum.chunk_by(&(&1))
        |> Enum.sort_by(&length/1, &>=/2)
        |> List.first
        |> List.first
    end

    def run_2 do
        File.read!('day6.txt')
        |> String.split
        |> Enum.map(&String.graphemes/1)
        |> List.zip
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&least_common_letter/1)
        |> Enum.join
    end

    def least_common_letter(list) do
        list
        |> Enum.sort
        |> Enum.chunk_by(&(&1))
        |> Enum.sort_by(&length/1, &<=/2)
        |> List.first
        |> List.first
    end
end
