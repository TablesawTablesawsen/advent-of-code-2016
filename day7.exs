defmodule Day7 do
    @abba ~r{(\w)(?!\1)(\w)\2\1}
    @bracketed_abba ~r{\[\w*(\w)(?!\1)(\w)\2\1\w*]}

    def supports_TLS string do
        if Regex.match? @bracketed_abba, string do
            false
        else
            @bracketed_abba
            |> Regex.split(string)
            |> Enum.any?(&(Regex.match? @abba, &1))
        end
    end

    def run do
        File.read!('day7.txt')
        |> String.split
        |> Enum.count(&supports_TLS/1)
    end
end
