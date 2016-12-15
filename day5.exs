defmodule Day5 do
    def password(door, prefix) do
        Stream.unfold(0, fn i -> {"#{door}#{i}", i+1} end)
        |> Stream.map(&hash/1)
        |> Stream.filter(&(String.starts_with? &1, prefix))
        |> Stream.map(&(String.slice(&1, String.length(prefix), 1)))
        |> Stream.each(&IO.puts/1)
        |> Enum.take(8)
        |> Enum.join
    end

    def hash(str) do
        :crypto.hash(:md5, str)
        |> Base.encode16
    end
end