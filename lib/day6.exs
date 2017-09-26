defmodule Day6 do
    def run do
        input_by_columns
        |> Enum.map(&most_common_letter/1)
        |> Enum.join
    end

    def run_2 do
        input_by_columns
        |> Enum.map(&least_common_letter/1)
        |> Enum.join
    end

    defp input_by_columns do
        File.read!('day6.txt')
        |> String.split
        |> Enum.map(&String.graphemes/1)
        |> List.zip
        |> Enum.map(&Tuple.to_list/1)
    end

    def least_common_letter(list) do
        _common_letter list, &<=/2
    end

    def most_common_letter(list) do
        _common_letter list, &>=/2
    end

    defp _common_letter(list, sort) do
        list
        |> Enum.sort
        |> Enum.chunk_by(&(&1))
        |> Enum.sort_by(&length/1, sort)
        |> List.first
        |> List.first
    end
end
