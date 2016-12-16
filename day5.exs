defmodule Day5 do

    def password(door, prefix) do
        prefixed_hashes(door, prefix)
        |> Stream.map(&(String.slice &1, 0, 1))
        |> Stream.each(&IO.puts/1)
        |> Enum.take(8)
        |> Enum.join
    end

    def prefixed_hashes(door, prefix) do
        Stream.unfold(0, fn i -> {"#{door}#{i}", i+1} end)
        |> Stream.map(&hash/1)
        |> Stream.filter(&(String.starts_with? &1, prefix))
        |> Stream.map(&(String.replace_prefix &1, prefix, ""))
    end

    def fancy_password(door, prefix) do
        blank_password = List.duplicate -1, 8

        prefixed_hashes(door, prefix)
        |> Enum.reduce_while(blank_password, &update_password/2)
        |> print_password
    end

    def update_password(hash, password) do
        position = String.slice(hash, 0, 1) |> String.to_integer(16)
        value = String.slice(hash, 1, 1) |> String.to_integer(16)

        add_letter(password, position, value)
        |> password_complete
    end

    def add_letter(password, position, value) do
        if (Enum.at password, position, 0) > -1 do
            password
        else
            List.replace_at password, position, value
        end
    end

    def password_complete(password) do
        if Enum.all? password, &(&1 > -1) do
            {:halt, password}
        else
            excite_viewer password
            {:cont, password}
        end
    end

    def excite_viewer(password) do
        password
        |> Enum.map(&scramble/1)
        |> print_password
    end

    def print_password(password) do
        password
        |> Enum.map(&(Integer.to_string(&1, 16)))
        |> Enum.join
        |> IO.puts
    end

    def scramble(digit) do
        if digit > -1 do
            digit
        else
            :rand.uniform(16) - 1
        end
    end

    def hash(str) do
        :crypto.hash(:md5, str)
        |> Base.encode16
    end
end