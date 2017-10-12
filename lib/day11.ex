require Astar

defmodule Day11 do
    def test do
        path = RTF.shortest_path_to_goal RTF.test
        length(path)
    end

    # 9.8s
    def part_one do
        path = RTF.shortest_path_to_goal RTF.real
        length(path)
    end

    # 16m 6s
    def part_two do
        path = RTF.shortest_path_to_goal RTF.realer
        length(path)
    end
end

defmodule RTF do
    def astar_env do
        {&RTF.possible_moves/1, &RTF.edge_cost/2, &RTF.heuristic_to_state/2}
    end

    def shortest_path_to_goal rtf do
        Astar.astar RTF.astar_env, rtf, RTF.goal(rtf)
    end

    def test do
        f1 = MapSet.new [{:H, :chip}, {:Li, :chip}]
        f2 = MapSet.new [{:H, :generator}]
        f3 = MapSet.new [{:Li, :generator}]
        f4 = %MapSet{}
        %{  floors: %{1 => f1, 2 => f2, 3 => f3, 4 => f4},
            elevator: 1
        }
    end

    def goal %{floors: floors} do
        f1 = %MapSet{}
        f2 = %MapSet{}
        f3 = %MapSet{}
        f4 = for {_, floor} <- floors, item <- floor, into: %MapSet{}, do: item
        %{  floors: %{1 => f1, 2 => f2, 3 => f3, 4 => f4},
            elevator: 4
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

    def realer do
        f1 = MapSet.new [{:Tm, :generator}, {:Tm, :chip}, {:Pu, :generator}, {:Sr, :generator}, {:El, :generator}, {:El, :chip}, {:Dl, :generator}, {:Dl, :chip}]
        f2 = MapSet.new [{:Pu, :chip}, {:Sr, :chip}]
        f3 = MapSet.new [{:Pm, :generator}, {:Pm, :chip}, {:Ru, :generator}, {:Ru, :chip}]
        f4 = %MapSet{}
        %{  floors: %{1 => f1, 2 => f2, 3 => f3, 4 => f4},
            elevator: 1
        }
    end

    def directory %{floors: floors, elevator: elevator_location} do
        directory = %{elevator: elevator_location}
        for {level, floor} <- floors, item <- floor, into: directory, do: {item, level}
    end

    def edge_cost(_, _), do: 1

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

    def heuristic_to_state rtf1, rtf2 do
        directory1 = RTF.directory rtf1
        directory2 = RTF.directory rtf2
        Enum.reduce(directory1, 0, fn {item, flr}, acc -> acc + abs(flr - directory2[item]) end)
    end

end
