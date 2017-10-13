require Astar
require Integer

defmodule Day13 do
    def run do
        length(ZorkFarm.shortest_path {7,4})
    end
end

defmodule ZorkFarm do
    @astar_env {&ZorkFarm.possible_moves/1, &ZorkFarm.edge_cost/2, &ZorkFarm.heuristic_to_state/2}
    @lobby {1,1}
    @favorite_number 10

    def shortest_path goal do
        Astar.astar @astar_env, @lobby, goal
    end

    def edge_cost(_a, _b), do: 1

    def possible_moves {x, y} do
        [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
        |> Enum.filter(&is_open/1)
    end


    def is_open({x, y}) when x < 0 or y < 0, do: false
    def is_open {x, y} do
        (x*x + 3*x + 2*x*y + y + y*y + @favorite_number)
        |> Integer.to_string(2)
        |> String.graphemes
        |> Enum.count(&(&1 == "1"))
        |> Integer.is_even
    end

    def heuristic_to_state {x1, y1},{x2,y2} do
        abs(x1 - x2) + abs(y1 - y2)
    end

end
