defmodule Day10 do
    @rx ~r{^(?<starttype>bot|value) (?<startnum>\d*) (?:goes to (?<intype>bot|output) (?<innum>\d*)|gives low to (?<lowtype>bot|output) (?<lownum>\d*) and high to (?<hightype>bot|output) (?<highnum>\d*))}

    def get_input do
        File.read!('day10.txt')
        |> String.split("\n")
    end

    def run do
        get_input
        |> Enum.map(&(Regex.named_captures @rx, &1))
        |> Enum.map(&to_instructions/1)
        |> Floor.build
        |> Floor.run
    end

    def to_instructions %{"starttype" => "value", "startnum" => chip, "intype" => type, "innum" => name} do
        { :input, String.to_integer(chip), {type, name} }
    end

    def to_instructions %{"starttype" => "bot", "startnum" => name, "lowtype" => low_type, "lownum" => low_name, "hightype" => high_type, "highnum" => high_name} do
        { :bot, name, {high_type, high_name}, {low_type, low_name} }
    end

    def run_part_one do
        %{bots: bots} = run
        {name, _bot}  = Enum.find bots, fn {_name, %{inv: inv} } -> inv == {17, 61} end
        name
    end

    def run_part_two do
        %{outputs: outputs} = run
        outputs["0"] * outputs["1"] * outputs["2"]
    end
end

defmodule Robot do
    defstruct low: nil, high: nil, inv: {nil, nil}, done: false

    def receive %{ inv: {nil, nil} } = robot, chip do
        %Robot{robot | inv: {chip, nil} }
    end

    def receive %{ inv: {chip_1, nil} } = robot, chip_2 do
        [low, high] = Enum.sort [chip_1, chip_2]

        %Robot{robot | inv: {low, high} }
    end

    def deactivate robot do
        %Robot{robot | done: true}
    end

    def is_ready? %{inv: {_, nil} } do
        false
    end

    def is_ready? %{done: done} do
        not done
    end
end

defmodule Floor do
    def build instructions do
        build %{inputs: [], bots: %{}, outputs: %{}}, instructions
    end

    def build floor, [] do
        floor
    end

    def build floor, [line | instructions] do
        floor
        |> create_stop(line)
        |> build(instructions)
    end

    def create_stop %{bots: bots} = floor, {:bot, name, high, low} do
        %{ floor | bots: Map.put(bots, name, %Robot{high: high, low: low}) }
    end

    def create_stop %{inputs: inputs} = floor, {:input, chip, destination} do
        %{ floor | inputs: [{chip, destination} | inputs] }
    end

    def run floor do
        primed_floor = discharge_inputs floor
        ready_bots = Enum.filter primed_floor.bots, fn {_name, robot} -> Robot.is_ready? robot end
        run_bots primed_floor, ready_bots
    end

    def run_bots floor, [] do
        ready_bots = Enum.filter floor.bots, fn {_name, robot} -> Robot.is_ready? robot end
        if ready_bots == [] do
            floor
        else
            run_bots floor, ready_bots
        end
    end

    def run_bots floor, [{name, bot} | ready_bots] do
        floor
        |> discharge_robot(bot)
        |> update_in([:bots, name], &Robot.deactivate/1)
        |> run_bots(ready_bots)
    end

    def discharge_robot floor, %{inv: {low_chip, high_chip}, high: high_dest, low: low_dest} do
        floor
        |> send_chip({low_chip, low_dest})
        |> send_chip({high_chip, high_dest})
    end


    def discharge_inputs %{inputs: inputs} = floor do
        Enum.reduce inputs, floor, &(send_chip &2, &1)
    end

    def send_chip floor, {chip, {"bot", name}} do
        update_in floor[:bots][name], &(Robot.receive &1, chip)
    end

    def send_chip floor, {chip, {"output", name}} do
        put_in floor[:outputs][name],  chip
    end
end