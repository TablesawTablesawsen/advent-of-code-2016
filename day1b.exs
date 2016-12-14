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

    def distance_from_origin(%Location{x: x, y: y}) do
        abs(x) + abs(y)
    end
end

defmodule Position do
    defstruct orientation: :up, location: %Location{}, final_location: nil, history: []

    @degree_map %{
        up: 0,
        right: 90,
        down: 180,
        left: 270
    }
    @direction_map %{
        0 => :up,
        90 => :right,
        180 => :down,
        270 => :left
    }

    def rotate(%Position{orientation: orientation} = position, turn) do
        new_direction = dir_to_deg(orientation) + dir_to_deg(turn)
                        |> rem(360)
                        |> deg_to_dir

        %Position{ position | orientation: new_direction}
    end

    def forward(position, 0) do
        position
    end

    def forward(%Position{final_location: %Location{}} = position, _) do
        position
    end

    def forward(%Position{orientation: orientation, location: location} = position, distance) do
        %Position{ position | location: Location.move(location, orientation, 1)}
        |> check_location
        |> forward(distance - 1)
    end

    def check_location(%Position{location: location, history: history} = position) do
        if Enum.member?(history, location) do
            %Position{position | final_location: location}
        else
            %Position{position | history: [location | history]}
        end
    end

    def dir_to_deg(direction) do
        @degree_map[direction]

    end

    def deg_to_dir(degrees) do
        @direction_map[degrees]
    end

    def follow_directions(directions) do
        follow_directions(%Position{}, directions)
    end

    def follow_directions(%Position{final_location: %Location{}} = position, _directions) do
        position
    end

    def follow_directions(%Position{location: location} = position, []) do
        %Position{position | final_location: location}
    end

    def follow_directions(position, [{turn, distance} | directions]) do
        position
        |> Position.rotate(turn)
        |> Position.forward(distance)
        |> follow_directions(directions)
    end
end

defmodule Day1b do
    def run do
        File.read!('day1.txt')
        |> String.split(", ")
        |> Enum.map(&translate_step/1)
        |> Position.follow_directions
        |> Map.fetch!(:final_location)
        |> Location.distance_from_origin
    end

    defp translate_step("R" <> number) do
        {:right, String.to_integer(number)}
    end

    defp translate_step("L" <> number) do
        {:left, String.to_integer(number)}
    end

end

IO.puts Day1b.run