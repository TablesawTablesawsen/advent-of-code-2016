defmodule Day11 do
    def test do
        path = Astar.search RTF.test, &RTF.heuristic_to_goal/1, &RTF.possible_moves/1
        length(path) - 1
    end

    def part_one do
        path = Astar.search RTF.real, &RTF.heuristic_to_goal/1, &RTF.possible_moves/1
        length(path) - 1
    end

end

defmodule RTF do

    def test do
        f1 = MapSet.new [{:H, :chip}, {:Li, :chip}]
        f2 = MapSet.new [{:H, :generator}]
        f3 = MapSet.new [{:Li, :generator}]
        f4 = %MapSet{}
        %{  floors: %{1 => f1, 2 => f2, 3 => f3, 4 => f4},
            elevator: 1
        }
    end

    def real do
        f1 = MapSet.new [{:Tm, :generator}, {:Tm, :chip}, {:Pu, :generator}, {:Sr, :generator}]
        f2 = MapSet.new [{:Pu, :chip}, {:Sr, :chip}]
        f3 = MapSet.new [{:Pm, :generator}, {:Pm, :chip}, {:Ru, :generator}, {:Ru, :chip}]
        f4 = %MapSet{}
        %{  floors: %{1 => f1, 2 => f2, 3 => f3, 4 => f4},
            elevator: 1
        }
    end

    def combination(0, _), do: [[]]
    def combination(_, []), do: []
    def combination(n, [x|xs]) do
      (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
    end

    def possible_elevators %{elevator: floor} = rtf do
         list = MapSet.to_list rtf.floors[floor]
         combination(2, list) ++ combination(1, list)
    end

    def possible_moves rtf do
        elevators = possible_elevators rtf

        up = if Map.has_key?(rtf.floors, rtf.elevator + 1) do
                Enum.map(elevators, &(move_elevator rtf, &1, rtf.elevator + 1))
             else
                []
             end
        dn = if Map.has_key?(rtf.floors, rtf.elevator - 1) do
                Enum.map(elevators, &(move_elevator rtf, &1, rtf.elevator - 1))
             else
                []
             end

        Enum.filter (up ++ dn), &RTF.is_valid?/1
    end

    def move_elevator rtf, el_inv, floor do
        new_rtf = Enum.reduce el_inv, rtf, &(move_item &2, &1, floor)
        %{new_rtf | elevator: floor}
    end

    def is_valid? rtf do
        Map.values(rtf.floors)
        |>  Enum.all?(fn floor ->
                Enum.all? floor, &(item_is_valid? &1, floor)
            end)
    end

    def item_is_valid? {el, type}, floor do
        type == :generator ||
            not Enum.any?(floor, fn {_, type} -> type == :generator end) ||
            MapSet.member? floor, {el, :generator}
    end


    def move_item rtf, item, floor do
        rtf
        |> update_in([:floors, rtf.elevator], &(MapSet.delete &1, item))
        |> update_in([:floors, floor], &(MapSet.put &1, item))
    end

    def is_goal %{floors: floors} do
        floors
        |> Map.keys
        |> Enum.sort(&(&1 >= &2))
        |> List.delete_at(0)
        |> Enum.all?(&(floors[&1] == %MapSet{}))
    end

    def heuristic_to_goal %{floors: floors} do
        moves = floors
            |> Map.keys
            |> Enum.sort(&(&1 >= &2))
            |> Enum.with_index
            |> Enum.reduce(0, fn {f, i}, acc -> acc + i * MapSet.size floors[f] end)

        (moves/2)
        |> Float.ceil
        |> trunc
    end

    def equal?(%{elevator: el1}, %{elevator: el2}) when el1 != el2 do
        false
    end

    def equal?(rtf1, rtf2) do
        Map.keys(rtf1.floors)
        |> Enum.all?(&(MapSet.equal? rtf1.floors[&1], rtf2.floors[&1]))
    end

    def in_list? rtf, list do
        Enum.any? list, &(RTF.equal? &1, rtf)
    end
end

defmodule Astar do
    def search start, heuristic, moveset do
        %{
            open_set: %{start => heuristic.(start)},
            closed_set: %{start => 0},
            came_from: %{start: nil}
        }
        |> traverse(heuristic, moveset)
    end

    def traverse %{open_set: %{}}, _, _, _ do
        nil
    end

    def traverse astar, heuristic, moveset do
        {current, _} = Enum.min_by astar.open_set, fn {_, v} -> v end
        IO.puts map_size(astar.open_set)
        if heuristic.(current) == 0 do
            reconstruct_path astar, current
        else
            new_cost = astar.closed_set[current] + 1
            new_states = Enum.filter moveset.(current),
                &( (not &1 in Map.keys(astar.closed_set)) ||
                    new_cost < astar.closed_set[&1])

            Enum.reduce(new_states, astar, fn state, astar ->
                astar
                |> put_in([:open_set, state], new_cost + heuristic.(state))
                |> put_in([:closed_set, state], new_cost)
                |> put_in([:came_from, state], current)
            end)
            |> update_in([:open_set], &(Map.delete &1, current))
            |> traverse(heuristic, moveset)
        end
    end

    def reconstruct_path astar, state do
        reconstruct_path astar, astar.came_from[state], [state]
    end

    def reconstruct_path _astar, nil, list do
        list
    end

    def reconstruct_path astar, state, list do
        reconstruct_path astar, astar.came_from[state], [state | list]
    end

end