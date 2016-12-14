defmodule Day2b do
    @instruction_map %{
        "R" => :right,
        "L" => :left,
        "U" => :up,
        "D" => :down
    }

    def run do
        File.read!('/home/tablesaw/erlang/elixir/advent/day2.txt')
        |> String.split
        |> Enum.map(&Day2.string_to_instructions/1)
        |> Enum.reduce([], &Keypad.find_locations/2)
        |> Enum.reverse
        |> Enum.map(&Keypad.location_to_number/1)
    end

    def string_to_instructions(string) do
        string
        |> String.graphemes
        |> Enum.map(&Map.fetch!(@instruction_map, &1))
    end
end

defmodule Location do
    defstruct x: 0, y: 0

    def move(%Location{x: x} = location, :right, distance) do
        %Location{ location | x: x + distance }
    end

    def move(%Location{x: x} = location, :left, distance) do
        %Location{ location | x: x - distance }
    end

    def move(%Location{y: y} = location, :up, distance) do
        %Location{ location | y: y + distance }
    end

    def move(%Location{y: y} = location, :down, distance) do
        %Location{ location | y: y - distance }
    end
end


defmodule Keypad do
    @keymap %{
        %Location{x: 0, y: 2}   => "1",
        %Location{x: -1, y: 1}  => "2",
        %Location{x: 0, y: 1}   => "3",
        %Location{x: 1, y: 1}   => "4",
        %Location{x: -2, y: 0}  => "5",
        %Location{x: -1, y: 0}  => "6",
        %Location{x: 0, y: 0}   => "7",
        %Location{x: 1, y: 0}   => "8",
        %Location{x: 2, y: 0}   => "9",
        %Location{x: -1, y: -1} => "A",
        %Location{x: 0, y: -1}  => "B",
        %Location{x: 1, y: -1}  => "C",
        %Location{x: 0, y: -2}  => "D",
    }

    def find_locations(instructions, []) do
        [_find_location(%Location{}, instructions)]
    end

    def find_locations(instructions, [prev_location | _] = acc) do
        [_find_location(prev_location, instructions) | acc]
    end

    defp _find_location(location, []) do
        location
    end

    defp _find_location(location, [step | instructions]) do
        location
        |> conditional_move(Location.move(location, step, 1))
        |> _find_location(instructions)
    end

    def conditional_move(location, new_location) do
        if Map.has_key?(@keymap, new_location) do
            new_location
        else
            location
        end
    end

    def location_to_number(location) do
        @keymap
        |> Map.fetch!(location)
    end
end

IO.puts Day2b.run