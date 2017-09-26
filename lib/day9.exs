defmodule Day9 do
    @rx ~r{\((\d*)x(\d*)\)}

    def get_input do
        File.read!('day9.txt')
    end

    def run do
        get_input
        |> decompress
        |> String.length
    end

    def run_2 do
        get_input
        |> decompressed_length
    end

    def decompress string do
        decompress string, ""
    end

    defp decompress [head, marker, tail], big_string do
        [_, len, dupe] = Regex.run @rx, marker

        {target, remaining} = String.split_at tail, String.to_integer(len)

        decompress remaining, big_string <> head <> String.duplicate(target, String.to_integer(dupe))
    end

    defp decompress [tail], big_string do
        decompress "", big_string <> tail
    end

    defp decompress "", big_string do
        big_string
    end

    defp decompress string, big_string do
        string
        |> String.split(@rx, [parts: 2, include_captures: true])
        |>decompress(big_string)
    end

    def decompressed_length string do
        decompressed_length string, 0
    end

    defp decompressed_length [head, marker, tail], full_length do
        [_, len, dupe] = Regex.run @rx, marker

        {target, remaining} = String.split_at tail, String.to_integer(len)

        decompressed_length remaining, full_length + String.length(head) + String.to_integer(dupe) * decompressed_length(target)
    end

    defp decompressed_length [tail], full_length do
        decompressed_length "", full_length + String.length(tail)
    end

    defp decompressed_length "", full_length do
        full_length
    end

    defp decompressed_length string, full_length do
        string
        |> String.split(@rx, [parts: 2, include_captures: true])
        |>decompressed_length(full_length)
    end

end