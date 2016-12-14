defmodule Position do
    defstruct direction: 0, x: 0, y: 0

    def find_position (directions) do
        find_position %Position{}, directions
    end

    defp find_position(position, [step | directions]) do
        step
        |> handle_step()
        |> update_position(position)
        |> find_position(directions)
    end

    defp find_position(position, []) do
        position
    end

    defp handle_step("R" <> number) do
        {:right, String.to_integer(number)}
    end

    defp handle_step("L" <> number) do
        {:left, String.to_integer(number)}
    end

    defp update_position({turn, distance}, position) do
        position
        |> change_direction(turn)
        |> move_distance(distance)
    end

    defp change_direction(position, :right) do
        update_in(position.direction, &(rem(&1+90, 360)))
    end

    defp change_direction(position, :left) do
        update_in(position.direction, &(rem(&1+270, 360)))
    end

    defp move_distance(%Position{direction: 0} = position, distance) do
        update_in(position.x, &(&1 + distance))
    end

    defp move_distance(%Position{direction: 180} = position, distance) do
        update_in(position.x, &(&1 - distance))
    end

    defp move_distance(%Position{direction: 90} = position, distance) do
        update_in(position.y, &(&1 + distance))
    end

    defp move_distance(%Position{direction: 270} = position, distance) do
        update_in(position.y, &(&1 - distance))
    end


end