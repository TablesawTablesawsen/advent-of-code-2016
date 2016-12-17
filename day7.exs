defmodule Day7 do
    @abba ~r{(\w)(?!\1)(\w)\2\1}
    @hypernet ~r{\[\w*\]}
    @hypernet_abba ~r{\[\w*(\w)(?!\1)(\w)\2\1\w*]}
    @aba ~r{(?=(\w)(?!\1)(\w)\1)}

    def get_input do
        File.read!('day7.txt')
        |> String.split
    end

    def supports_TLS string do
        if Regex.match? @hypernet_abba, string do
            false
        else
            @hypernet
            |> Regex.split(string)
            |> Enum.any?(&(Regex.match? @abba, &1))
        end
    end

    def supports_SSL string do
        [h, s] = Regex.split(@hypernet, string, include_captures: true)

        #  Elixir 1.4
        # |> Enum.split_with(&(Regex.match? @hypernet, &1))
        # |> Enum.map(&Tuple.to_list/1)

        #  Elixir 1.3
        |> Enum.partition(&(Regex.match? @hypernet, &1))
        |> Tuple.to_list

        |> Enum.map(&aba_list/1)

        not MapSet.disjoint? hypernet_tuples(h), supernet_tuples(s)
    end

    def aba_list list do
]        Enum.flat_map list, &(Regex.scan @aba, &1)
    end

    def hypernet_tuples list do
        Enum.into list, %MapSet{}, fn [_, a, b] -> {a,b} end
    end

    def supernet_tuples list do
        Enum.into list, %MapSet{}, fn [_, a, b] -> {b,a} end
    end

    def run do
        Enum.count get_input, &supports_TLS/1
    end

    def run_2 do
        Enum.count get_input, &supports_SSL/1
    end
end
