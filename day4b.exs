defmodule Day4b do
    @a_value 97
    @hyphen_value 45
    @space_value 32

    def run do
        File.read!("day4.txt")
        |> String.split
        |> Enum.map(&str_to_room/1)
        |> Enum.filter(&is_real?/1)
        |> Enum.map(&decode_room/1)
    end

    def str_to_room(str) do
        {list, [ id, checksum ]} =  str
                                    |> String.split(["-", "[", "]"], trim: true)
                                    |> Enum.split(-2)
        {Enum.join(list,"-"), String.to_integer(id), checksum}
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
        |> String.replace("-", "")
        |> String.graphemes
        |> count_elements
        |> Map.to_list
        |> letter_sort
        |> Enum.take(5)
        |> Enum.map( fn ({l, _} )-> l end )
        |> Enum.join
    end

    def decode_room( {name, id, checksum} ) do
        {caesar_shift(name, id), id, checksum}
    end

    def caesar_shift(string, value) when is_binary(string) do
        string
        |> String.to_charlist
        |> caesar_shift(value)
        |> List.to_string
    end

    def caesar_shift(charlist, value) do
        Enum.map charlist, &(char_shift &1, value)
    end

    defp char_shift(char, _) when char == @hyphen_value do
        @space_value
    end

    defp char_shift(char, value) do
        rem(char - @a_value + value, 26) + @a_value
    end

end

Day4b.run
|> Enum.filter(fn ({name, _, _}) -> String.contains? name, "north" end)
|> Enum.each(fn ({name, id, _}) -> IO.puts "Room: #{name}, id: #{id}" end)