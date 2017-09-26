defmodule Day4a do
    def run do
        File.read!("day4.txt")
        |> String.split
        |> Enum.map(&str_to_room/1)
        |> Enum.filter(&is_real?/1)
        |> Enum.reduce(0, fn ({_, id, _}, acc) -> acc + id end)

    end

    def str_to_room(str) do
        {list, [ id, checksum ]} =  str
                                    |> String.split(["-", "[", "]"], trim: true)
                                    |> Enum.split(-2)
        {Enum.join(list), String.to_integer(id), checksum}
    end

    def is_real?({name, _id, check}) do
        checksum(name) == check
    end

    def count_elements (list) do
        Enum.reduce list, %{}, fn (letter, acc) ->
            Map.update(acc, letter, 1, &(&1 + 1))
        end
    end

    def letter_sort (list) do
        Enum.sort list, fn ({l1, c1}, {l2, c2}) ->
            c1 > c2 or ( c1 == c2 and l1 < l2)
        end
    end


    def checksum(name) do
        name
        |> String.graphemes
        |> count_elements
        |> Map.to_list
        |> letter_sort
        |> Enum.take(5)
        |> Enum.map( fn ({l, _} )-> l end )
        |> Enum.join
    end
end

IO.puts Day4a.run