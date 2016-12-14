defmodule Location do
    defstruct x: 0, y: 0

    def move_right(%Location{x: x} = location, distance) do
        %Location{ location | x: x + distance))
    end

    def move_left(%Location{x: x} = location, distance) do
        %Location{ location | x: x - distance))
    end

    def move_up(%Location{y: y} = location, distance) do
        %Location{ location | y: y + distance))
    end

    def move_down(%Location{y: y} = location, distance) do
        %Location{ location | y: y - distance))
    end
end

defmodule Step do

    defp handle_step("R" <> number) do
        {:right, String.to_integer(number)}
    end

    defp handle_step("L" <> number) do
        {:left, String.to_integer(number)}
    end
end


defmodule Position do
    defstruct direction: 0, location: %Location{x: 0, y: 0}, history: nil, answer: nil

    def find_position (directions) do
        default = %Position{}
        find_position %Position{default | history: MapSet.new([default.location])}, directions
    end

    defp find_position(position, [step | directions]) do
        position
        |> update_position(step)
        |> find_position(directions)
    end

    defp find_position(position, []) do
        position
    end

    defp update_position(position, {turn, distance}, ) do
        position
        |> change_direction(turn)
        |> move_distance(distance)
    end

    def change_direction(%Position{direction: direction} = position, :right) do
        %Position{position | direction: rem(direction + 90, 360) }
    end

    def change_direction(%Position{direction: direction} = position, :left) do
        %Position{position | direction: rem(direction + 270, 360) }
    end

    def change_direction(%Position{direction: direction} = position, :reverse) do
        %Position{position | direction: rem(direction + 180, 360) }
    end

    def change_direction(position, _) do
        position
    end

    def move_distance(%Position{answer: %{}} = position, _) do
        position
    end

    def move_distance(position, 0) do
        position
    end

    def move_distance(%Position{direction: 0} = position, distance) do
        move_distance(position, distance, &Location.move_up/2)
    end

    def move_distance(%Position{direction: 90} = position, distance) do
        move_distance(position, distance, &Location.move_right/2)
    end

    def move_distance(%Position{direction: 180} = position, distance) do
        move_distance(position, distance, &Location.move_down/2)
    end

    def move_distance(%Position{direction: 270} = position, distance) do
        move_distance(position, distance, &Location.move_left/2)
    end

    def move_distance(position, 0, _move_fn) do
        position
    end

    def move_distance(&Position{location: location} = position, distance, move_fn) do
        %Position{position | location: move_fn(location, 1))
        |> check_location
        |> move_distance(distance - 1, move_fn)
    end


    defp check_location(%Position{history: history, location: location} = position) do
        if MapSet.member?(history, location) do
            %Position(position | answer: location)
        else
            %Position(position | history: MapSet.put(history, location))
        end
    end
end

