defmodule Day2a do
    @instruction_map %{
        "R" => :right,
        "L" => :left,
        "U" => :up,
        "D" => :down
    }

    def run do
        File.read!('day2.txt')
        |> String.split
        |> Enum.map(&string_to_instructions/1)
        |> Enum.reduce([], &Keypad.find_locations/2)
        |> Enum.reverse
        |> Enum.map(&Keypad.location_to_number/1)
        |> Enum.map(&Integer.to_string/1)
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
    @x_max 1
    @x_min -1
    @y_max 1
    @y_min -1

    def find_locations(instructions, []) do
        [_find_location(%Location{}, instructions)]
    end

    def find_locations(instructions, [prev_location | _] = acc) do
        [_find_location(prev_location, instructions) | acc]
    end

    defp _find_location(location, []) do
        location
    end

    defp _find_location(%Location{} = location, [step | instructions]) do
        location
        |> Location.move(step, 1)
        |> keep_in_bounds
        |> _find_location(instructions)
    end

    def keep_in_bounds(%{x: x} = location)
        when x > @x_max do

        %Location{location | x: @x_max}
        |> keep_in_bounds
    end

    def keep_in_bounds(%{x: x} = location)
        when x < @x_min do

        %Location{location | x: @x_min}
        |> keep_in_bounds
    end

    def keep_in_bounds(%{y: y} = location)
        when y > @y_max do

        %Location{location | y: @y_max}
        |> keep_in_bounds
    end

    def keep_in_bounds(%{y: y} = location)
        when y < @y_min do

        %Location{location | y: @y_min}
        |> keep_in_bounds
    end

    def keep_in_bounds(location) do
        location
    end

    def location_to_number(%Location{x: x, y: y}) do
        ((@x_max - @x_min + 1) * (@y_max - y)) + (x - @x_min + 1)
    end

end

IO.puts Day2a.run