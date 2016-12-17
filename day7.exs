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
        Regex.split(@hypernet, string, include_captures: true)
        |> Enum.partition(&(Regex.match? @hypernet, &1))  #  Elixir 1.3
        |> protocol_split
        |> matching_pattern
    end

    def matching_pattern {hypernet, supernet} do
        not MapSet.disjoint? hypernet, supernet
    end

    def protocol_split {hypernet, supernet} do
        {hypernet_list(hypernet), supernet_list(supernet)}
    end

    def aba_list list do
        Enum.flat_map list, &(Regex.scan @aba, &1)
    end

    def hypernet_list list do
        list
        |> aba_list
        |> Enum.into(%MapSet{}, fn [_, a, b] -> {a,b} end)
    end

    def supernet_list list do
        list
        |> aba_list
        |> Enum.into(%MapSet{}, fn [_, a, b] -> {b,a} end)
    end

    def run do
        Enum.count get_input, &supports_TLS/1
    end

    def run_2 do
        Enum.count get_input, &supports_SSL/1
    end
end
